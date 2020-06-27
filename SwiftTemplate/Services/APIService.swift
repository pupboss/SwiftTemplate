//
//  APIService.swift
//  SwiftTemplate
//
//  Created by Jie Li on 28/2/20.
//  Copyright © 2020 Meltdown Research. All rights reserved.
//

import Foundation
import Alamofire

public enum ParamsType : Int {
    
    case json
    
    case form
}

final class AccessTokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Constants.apiHost + "/v1/auth/") == false else {
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
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    func fetchUserInfo(success: ((UserInfoModel) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        requestDecodable(path: "/v1/user/show", decodealeType: UserInfoModel.self, success: { (value) in
            if let success = success {
                success(value)
            }
        }, failure: failure)
    }

    func requestDecodable<T: Decodable>(path: String, decodealeType: T.Type, success: ((T) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        requestDecodable(method: .get, path: path, params: nil, paramsType: .form, decodealeType: decodealeType, success: success, failure: failure)
    }
    
    func requestDecodable<T: Decodable>(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType, decodealeType: T.Type, success: ((T) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let requestURL = Constants.apiHost + path
        
        let paramsEncoding: ParameterEncoding = paramsType == .form ? URLEncoding.default : JSONEncoding.default
        
        session.request(requestURL, method: method, parameters: params, encoding: paramsEncoding).validate(statusCode: 200..<300).responseDecodable(of: decodealeType) { response in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            print(
                """
                [Request]
                \(method.rawValue) \(String(describing: params))
                \(requestURL)
                [Response]
                \(response.response?.statusCode ?? 999) \(String(decoding: response.data ?? Data(), as: UTF8.self))
                """
            )
            switch response.result {
            case .success(let value):
                if let success = success {
                    success(value)
                }
            case .failure(let aError):
                let statusCode = response.response?.statusCode ?? 999

                if statusCode == 401 {
                    self.clearAuthAndReLogin()
                }
                
                if let failure = failure {
                    guard let error = try? JSONDecoder().decode(ErrorModel.self, from: response.data ?? Data()) else {
                        failure(ErrorModel(code: statusCode, message: aError.localizedDescription))
                        return
                    }
                    failure(error)
                }
            }
        }
    }
    
    func requestJSON(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let requestURL = Constants.apiHost + path
        
        let paramsEncoding: ParameterEncoding = paramsType == .form ? URLEncoding.default : JSONEncoding.default
        
        session.request(requestURL, method: method, parameters: params, encoding: paramsEncoding).validate(statusCode: 200..<300).responseJSON { response in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            print(
                """
                [Request]
                \(method.rawValue) \(String(describing: params))
                \(requestURL)
                [Response]
                \(response.response?.statusCode ?? 999) \(String(decoding: response.data ?? Data(), as: UTF8.self))
                """
            )
            switch response.result {
            case .success(let value):
                if let success = success {
                    success(value)
                }
            case .failure(let aError):
                let statusCode = response.response?.statusCode ?? 999

                if statusCode == 401 {
                    self.clearAuthAndReLogin()
                }
                
                if let failure = failure {
                    guard let error = try? JSONDecoder().decode(ErrorModel.self, from: response.data ?? Data()) else {
                        failure(ErrorModel(code: statusCode, message: aError.localizedDescription))
                        return
                    }
                    failure(error)
                }
            }
        }
    }
}
