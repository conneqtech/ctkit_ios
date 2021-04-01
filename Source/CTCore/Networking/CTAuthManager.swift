//
//  CTOAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift
import Alamofire

public class CTAuthManager: CTAuthManagerBase {
    private let apiConfig: CTApiConfig
    
    public init(withConfig config: CTApiConfig) {
        self.apiConfig = config
    }
    
    public func getClientToken() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            if (!Connectivity.isConnectedToInternet) {
                observer.onError(CTErrorHandler().handleNoInternet())
                return Disposables.create()
            }
            let url = URL(string: "\(self.apiConfig.fullUrl)/oauth")!
            let requestReference = Alamofire.request(url,
                                                     method: .post,
                                                     parameters: [
                                                        "client_id": self.apiConfig.clientId,
                                                        "client_secret": self.apiConfig.clientSecret,
                                                        "grant_type": "client_credentials"
                                                        
            ])
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data,
                            let getResponse = try? JSONDecoder().decode(CTCredentialResponse.self, from: data) else {
                                observer.onError(NSError(domain: "tbi", code: 500, userInfo: nil))
                                return
                        }
                        
                        observer.onNext(getResponse.accessToken)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(CTErrorHandler().handle(response: response))
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
    
    public func login(token: String, type: String) -> Observable<Any> {
        var parameters: [String: String] = [
            "client_id": self.apiConfig.clientId,
            "client_secret": self.apiConfig.clientSecret,
            "grant_type": type
        ]
        
        if (type == "facebook") {
            parameters["facebook_token"] = token
        }
        
        if (type == "google") {
            parameters["google_token"] = token
        }
        
        if (type == "apple") {
            parameters["id_token"] = token
        }
        
        return self.login(parameters: parameters)
    }
    
    public func login(username: String, password: String) -> Observable<Any> {
        let parameters: [String: String] = [
            "username": username,
            "password": password,
            "client_id": self.apiConfig.clientId,
            "client_secret": self.apiConfig.clientSecret,
            "grant_type": "password",
        ]
        
        return self.login(parameters: parameters)
    }
    
    private func login(parameters: [String: String]) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            if (!Connectivity.isConnectedToInternet) {
                observer.onError(CTErrorHandler().handleNoInternet())
                return Disposables.create()
            }
            let url = URL(string: "\(self.apiConfig.fullUrl)/oauth")!
            let requestReference = Alamofire.request(url,
                                                     method: .post,
                                                     parameters: parameters)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(CTCredentialResponse.self, from: data) else {
                            observer.onError(CTErrorHandler().handle(withDecodingError: nil))
                            return
                        }
                        
                        self.responseDebugger(.post, endpoint: "oauth", parameters: parameters, response: response)
                        
                        self.saveTokenResponse(getResponse)
                        observer.onNext(getResponse)
                        observer.onCompleted()
                    case .failure:
                        self.responseDebugger(.post, endpoint: "oauth", parameters: parameters, response: response)
                        observer.onError(CTErrorHandler().handle(response: response))
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
            
        }
    }
    
    func getRefreshToken() -> String {
        return retrieveDataFromStore(forKey: CTKit.REFRESH_TOKEN_KEY)
    }
    
    public func saveTokenResponse(_ tokenResponse: CTCredentialResponse) {
        CTKit.shared.authToken.onNext(tokenResponse)
        
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            let keychain = KeychainSwift()
            keychain.set(tokenResponse.accessToken, forKey: CTKit.ACCESS_TOKEN_KEY, withAccess: .accessibleAfterFirstUnlock)
            keychain.set(Date().addingTimeInterval(Double(tokenResponse.expiresIn)).toAPIDate(), forKey: CTKit.ACCESS_TOKEN_EXPIRE_TIME_KEY, withAccess: .accessibleAfterFirstUnlock)
            
            if let refreshToken = tokenResponse.refreshToken {
                keychain.set(refreshToken, forKey: CTKit.REFRESH_TOKEN_KEY, withAccess: .accessibleAfterFirstUnlock)
            }
            
        case .userDefaults:
            UserDefaults.standard.set(tokenResponse.accessToken, forKey: CTKit.ACCESS_TOKEN_KEY)
            UserDefaults.standard.set(Date().addingTimeInterval(Double(tokenResponse.expiresIn)).toAPIDate(),
                                      forKey: CTKit.ACCESS_TOKEN_EXPIRE_TIME_KEY)
            
            if let refreshToken = tokenResponse.refreshToken {
                UserDefaults.standard.set(refreshToken, forKey: CTKit.REFRESH_TOKEN_KEY)
            }
        default:
            print("NOTH")
        }
    }
    
    public func hasActiveSession() -> Bool {
        return true
    }
    
    public func getActiveSessionEndDate() -> Date {
        return Date()
    }
    
    public func getActiveSessionToken() -> String {
        return retrieveDataFromStore(forKey: CTKit.ACCESS_TOKEN_KEY)
    }
    
    public func terminateActiveSession() {
        // Kill the session
    }
}

extension CTAuthManager {
    private func retrieveDataFromStore(forKey key: String) -> String {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            return KeychainSwift().get(key) ?? ""
        case .userDefaults:
            return UserDefaults.standard.string(forKey: key) ?? ""
        default:
            return ""
        }
    }
    
    func responseDebugger(_ method: Alamofire.HTTPMethod,
                             endpoint: String,
                             parameters: [String: Any]? = nil,
                             response: DataResponse<Any>) {
        if !CTKit.shared.debugMode {
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601CT)
        
        print(".=========================================.")
        print("🌍[\(method)] \(self.apiConfig.fullUrl)/\(endpoint)")
        if let parameters = parameters {
            print("📄 Parameters:")
            print(parameters)
        }
        
        if let rData = response.data {
            print("♻️ Response with \(rData.count) bytes")
            
            if response.result.isFailure {
                print("⚠️ The call failed with the following error")
            } else {
                print("✅ The call succeeded with the following data")
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: rData, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        print(".=========================================.")
    }
}
