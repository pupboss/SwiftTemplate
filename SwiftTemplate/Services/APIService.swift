//
//  APIService.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 29/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import Foundation
import Alamofire

public enum ParamsType : Int {
    
    case json
    
    case form
}

final class AccessTokenInterceptor: Alamofire.RequestInterceptor {
    
    init() {
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://api.stripe.com") == true else {
            return completion(.success(urlRequest))
        }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(APIService.default.apiAuthToken ?? ""))
        completion(.success(urlRequest))
    }
}

class APIService {
    
    static let `default` = APIService()
    let manager = NetworkReachabilityManager(host: Constants.apiHost)
    
    // Properties
    var apiAuthToken: String?
    var networkReachable = true
    
    private lazy var session: Session = {

        let configuration = URLSessionConfiguration.af.default
        configuration.headers.add(.userAgent("\(Utils.appName())/\(Utils.appVersion())" + " (\(Utils.deviceModel()); iOS\(Utils.systemVersion()))"))
        let session = Session(configuration: configuration, interceptor:AccessTokenInterceptor())
        
        return session
    }()
    
    private init() {
        
        apiAuthToken = UserDefaults.standard.object(forKey: Constants.authTokenDefaultsKey) as? String
        manager?.startListening { status in
            print("Network Status Changed: \(status)")
        }
    }
    
    func clearAuthAndReLogin() {
        UserDefaults.standard.set(nil, forKey: Constants.authTokenDefaultsKey)
        
        apiAuthToken = nil
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController(rootViewController: ScanViewController())
    }
    
    func fetchUserInfo(success: ((UserInfoModel) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        request(method: .get, path: "/api/user-info", params: nil, paramsType: nil, success: { (data) in
            
            let dict = data as! [String: Any]
            let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            
            do {
                let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: data)
                if let success = success {
                    success(userInfo)
                }
                
            } catch {
                if let failure = failure {
                    failure(ErrorModel(code: 999, message: error.localizedDescription))
                }
            }
        }, failure: failure)
    }
    
    /// non-params get request
    ///
    /// - Parameters:
    ///   - path: String
    ///   - success: success()
    ///   - failure: failure()
    func request(path: String, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        request(method: .get, path: path, params: nil, paramsType: nil, success: success, failure: failure)
    }
    
    /// request
    ///
    /// - Parameters:
    ///   - method: .method
    ///   - path: String
    ///   - params: [:]
    ///   - paramsType: .type
    ///   - success: success()
    ///   - failure: failure()
    
    func request(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType?, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let requestURL = Constants.apiHost + path
        
        let paramsEncoding: ParameterEncoding = paramsType == .form ? URLEncoding.default : JSONEncoding.default
        
        session.request(requestURL, method: method, parameters: params, encoding: paramsEncoding, headers: nil).validate(statusCode: 200..<300).responseJSON { (responseObject) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            switch responseObject.result {
            case .success(let value):
                let responseDict = value as! [String : Any]
                print("success\n\(method.rawValue + "\n" + requestURL)\n\(String(describing: params))\n\(responseDict)")
                
                let errorCode = responseDict["errorCode"] as! Int
                
                if errorCode == 0 {
                    let data = responseDict["body"] as Any
                    if let success = success {
                        success(data)
                    }
                } else {
                    if let failure = failure {
                        
                        let msg = responseDict["message"] as? String
                        failure(ErrorModel(code: errorCode, message: msg ?? "Fatal error"))
                    }
                }
            case .failure(let error):
                print("failure\n\(method.rawValue + "\n" + requestURL)\n\(String(describing: params))\n\(error)")
                
                let statusCode = responseObject.response?.statusCode ?? 999
                
                if statusCode == 401 {
                    self.clearAuthAndReLogin()
                }
                
                if let failure = failure {
                    failure(ErrorModel(code: statusCode, message: error.localizedDescription))
                }
            }
        }
    }
    
    func createTokenWithCard(card: [String: Any], success: ((String?) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            SwiftProgressHUD.showWait()
        }
        let requestURL = "https://api.stripe.com/v1/tokens"
        let headers = HTTPHeaders(["Authorization": "Basic " + "\(Constants.stripeAppKey):".toBase64!, "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"])
        
        session.request(requestURL, method: .post, parameters: card, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { (responseObject) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                SwiftProgressHUD.hideAllHUD()
            }
            switch responseObject.result {
            case .success(let value):
                let responseDict = value as! [String : Any]
                print("\(requestURL)\n\(responseDict)")
                
                if let success = success {
                    success(responseDict["id"] as? String)
                }
            case .failure(let error):
                print("\(requestURL)\n\(error)")
                
                let statusCode = responseObject.response?.statusCode ?? 999
                
                if let failure = failure {
                    failure(ErrorModel(code: statusCode, message: error.localizedDescription))
                }
            }
        }
    }
}
