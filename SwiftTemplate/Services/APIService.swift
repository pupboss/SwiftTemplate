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

class AccessTokenAdapter: RequestAdapter {
    private let requireAuth: Bool
    
    init(requireAuth: Bool) {
        self.requireAuth = requireAuth
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if requireAuth {
            
            urlRequest.setValue(APIService.shared.apiAuthToken, forHTTPHeaderField: "x-auth-token")
        }
        
        return urlRequest
    }
}

class APIService {
    
    static let shared = APIService()
    let networkManager = NetworkReachabilityManager(host: Constants.apiHost)
    
    // Properties
    var apiAuthToken: String?
    var networkReachable = true
    
    private lazy var sManager: SessionManager = {
        let l = (UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>)[0]
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["User-Agent"] = "\(Utils.appName())/\(Utils.appVersion())" + " (\(Utils.deviceModel()); iOS\(Utils.systemVersion()))"
        defaultHeaders["Accept-Language"] = "\(l),en;q=0.8"
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        let sManager = Alamofire.SessionManager(configuration: configuration)
        
        return sManager
    }()
    
    private init() {
        
        apiAuthToken = UserDefaults.standard.object(forKey: Constants.authTokenDefaultsKey) as? String
        networkManager?.listener = { status in
            print("Network Status Changed: \(status)")
        }
        
        networkManager?.startListening()
    }
    
    func clearAuthAndReLogin() {
        UserDefaults.standard.set(nil, forKey: Constants.authTokenDefaultsKey)
        
        apiAuthToken = nil
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = UINavigationController(rootViewController: ViewController())
    }
    
    func request(path: String, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        request(method: .get, path: path, params: nil, paramsType: nil, requireAuth: true, success: success, failure: failure)
    }
    
    func request(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType?, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        request(method: method, path: path, params: params, paramsType: paramsType, requireAuth: true, success: success, failure: failure)
    }
    
    func request(method: HTTPMethod, path: String, params: [String: Any]?, paramsType: ParamsType?, requireAuth: Bool, success: ((Any) -> Void)?, failure: ((ErrorModel) -> Void)?) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let requestURL = Constants.apiHost + path
        
        let paramsEncoding: ParameterEncoding = paramsType == .form ? URLEncoding.default : JSONEncoding.default
        
        sManager.adapter = AccessTokenAdapter(requireAuth: requireAuth)
        
        sManager.request(requestURL, method: method, parameters: params, encoding: paramsEncoding, headers: nil).validate(statusCode: 200..<300).responseJSON { (responseObject) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            switch responseObject.result {
            case .success(let value):
                let responseDict = value as! [String : Any]
                print("success\n\(requestURL)\n\(responseDict)")
                
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
                print("failure\n\(requestURL)\n\(error)")
                
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
}
