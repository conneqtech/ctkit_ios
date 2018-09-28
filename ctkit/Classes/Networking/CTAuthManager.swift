//
//  CTOAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift
import Alamofire

public class CTAuthManager {
    
    private let ACCESS_TOKEN_KEY = "accessToken"
    private let REFRESH_TOKEN_KEY = "refreshToken"
    
    private let apiConfig:CTApiConfig
    
    public init(withConfig config:CTApiConfig) {
        self.apiConfig = config
    }
    
    public func getClientToken() -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            let url = URL(string: "\(self.apiConfig.fullUrl)/oauth")!
            let requestReference = Alamofire.request(url,
                                                     method: .post,
                                                     parameters: [
                                                        "client_id":self.apiConfig.clientId,
                                                        "client_secret":self.apiConfig.clientSecret,
                                                        "grant_type":"client_credentials"
                                                        
                ])
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(CTOAuth2TokenResponse.self, from: data) else {
                            observer.onError(NSError(domain: "tbi", code: 500, userInfo: nil))
                            return
                        }
                        
                        observer.onNext(getResponse.accessToken)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(response.error!)
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
    
    public func login(username: String, password: String) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            let url = URL(string: "\(self.apiConfig.fullUrl)/oauth")!
            let requestReference = Alamofire.request(url,
                                                    method: .post,
                                                   parameters: [
                                                    "username":username,
                                                    "password":password,
                                                    "client_id":self.apiConfig.clientId,
                                                    "client_secret":self.apiConfig.clientSecret,
                                                    "grant_type":"password"
                                                    
                ])
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(CTOAuth2TokenResponse.self, from: data) else {
                            observer.onError(response.error!)
                            return
                        }
                    
                        self.saveTokenResponse(getResponse)
                        observer.onNext(getResponse)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(response.error!)
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
    
    func getAccesToken() -> String {
        return retrieveDataFromStore(forKey: ACCESS_TOKEN_KEY)
    }
    
    func getRefreshToken() -> String {
        return retrieveDataFromStore(forKey: REFRESH_TOKEN_KEY)
    }
    
    func saveTokenResponse(_ tokenResponse: CTOAuth2TokenResponse) {
        switch CTBike.shared.credentialSaveLocation {
        case .keychain:
            let keychain = KeychainSwift()
            keychain.set(tokenResponse.accessToken, forKey: ACCESS_TOKEN_KEY)
            
            if let refreshToken = tokenResponse.refreshToken {
                keychain.set(refreshToken, forKey: REFRESH_TOKEN_KEY)
            }
            
        case .userDefaults:
            UserDefaults.standard.set(tokenResponse.accessToken, forKey: ACCESS_TOKEN_KEY)
            
            if let refreshToken = tokenResponse.refreshToken {
                UserDefaults.standard.set(refreshToken, forKey: REFRESH_TOKEN_KEY)
            }
        default:
            print("NOTH")
        }
    }
}

extension CTAuthManager {
    private func retrieveDataFromStore(forKey key: String) -> String {
        switch CTBike.shared.credentialSaveLocation {
        case .keychain:
            return KeychainSwift().get(key) ?? ""
        case .userDefaults:
            return UserDefaults.standard.string(forKey: key) ?? ""
        default:
            return ""
        }
    }
}
