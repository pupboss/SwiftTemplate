//
//  APIService.swift
//  SwiftTemplate
//
//  Created by Jie Li on 28/2/20.
//  Copyright © 2020 PUPBOSS. All rights reserved.
//

import Foundation
import Alamofire

public enum ParamsType : Int {
    
    case json
    
    case form
}

final class AccessTokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Constants.apiHost + "/auth/") == true else {
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
        let uaHeader = HTTPHeader.userAgent("\(Utils.appName())/\(Utils.appVersion())" + " (\(Utils.deviceModel()); iOS\(Utils.systemVersion()))")
        configuration.headers.add(uaHeader)
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
    }
    
    func fetchUserInfo(success: ((UserInfoModel) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        request(method: .get, path: "/api/user-info", params: nil, paramsType: .form, success: { (data) in
            
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
        request(method: .get, path: path, params: nil, paramsType: .form, success: success, failure: failure)
    }
    
    func request(method: HTTPMethod, path: String, params: [String: String]?, paramsType: ParamsType, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let requestURL = Constants.apiHost + path
        
        let paramsEncoder: ParameterEncoder = paramsType == .form ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder.default
        
        session.request(requestURL, method: method, parameters: params, encoder: paramsEncoder).validate(statusCode: 200..<300).responseJSON { response in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            switch response.result {
            case .success(let value):
                print("success\n\(method.rawValue + "\n" + requestURL)\n\(String(describing: params))\n\(value)")
                
                if let success = success {
                    success(value)
                }
            case .failure(let error):
                print("failure\n\(method.rawValue + "\n" + requestURL)\n\(String(describing: params))\n\(error)")
                
                let statusCode = response.response?.statusCode ?? 999
                
                if statusCode == 401 {
                    self.clearAuthAndReLogin()
                }
                
                if let failure = failure {
                    failure(ErrorModel(code: statusCode, message: error.localizedDescription))
                }
            }
        }
    }
}
