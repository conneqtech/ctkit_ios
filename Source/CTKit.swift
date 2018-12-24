//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public class CTKit {
    
    public static var shared:CTKit!
  
    
    public var restManager: CTRestManager!
    public var authManager: CTAuthManager!
    public var subscriptionManager: CTSubscriptionManager!
    public var authToken = PublishSubject<CTOAuth2TokenResponse>()
    
    private let ACTIVE_USER_ID_KEY = "activeUserId"
    
    private var _currentActiveUser: CTUserModel?
    
    internal var currentActiveUser: CTUserModel? {
        set(newActiveUser) {
            self.saveCurrentActiveUserId(user: newActiveUser)
            self._currentActiveUser = newActiveUser
        }
        
        get {
            return _currentActiveUser
        }
    }
    
    internal var currentActiveUserId: Int {
        get {
            return getCurrentActiveUserId()
        }
    }
    
    
    
    internal var credentialSaveLocation: CTOAuth2CredentialSaveLocation = .keychain
    
    private init(clientId: String, clientSecret: String, baseURL: String) {
        let APIConfig = CTApiConfig(withBaseUrl: baseURL,
                                    clientId: clientId,
                                    clientSecret: clientSecret,
                                    grantType: .clientCredentials)

        
        self.restManager = CTRestManager(withConfig: APIConfig)
        self.authManager = CTAuthManager(withConfig: APIConfig)
//        self.subscriptionManager = CTSubscriptionManager(withConfig: APIConfig)
    }
    
    public static func configure(withClientId clientId: String, clientSecret: String, baseURL: String) {
        CTKit.shared = CTKit.init(clientId: clientId, clientSecret: clientSecret, baseURL: baseURL)
    }
}

private extension CTKit {
    
    func saveCurrentActiveUserId(user: CTUserModel?) {
        guard let activeUser = user else {
            // Clear out storage
            print("Logging out")
            KeychainSwift().delete(ACTIVE_USER_ID_KEY)
            UserDefaults.standard.removeObject(forKey: ACTIVE_USER_ID_KEY)
            return
        }
        
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            KeychainSwift().set("\(activeUser.id)", forKey: ACTIVE_USER_ID_KEY)
        case .userDefaults:
            UserDefaults.standard.set("\(activeUser.id)", forKey: ACTIVE_USER_ID_KEY)
        case .none:
            print("User id not persisted")
        }
    }
    
    func getCurrentActiveUserId() -> Int {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            if let userId = KeychainSwift().get(ACTIVE_USER_ID_KEY) {
                return Int(userId)!
            } else {
                return -1
            }
        case .userDefaults:
            if let userId = UserDefaults.standard.string(forKey: ACTIVE_USER_ID_KEY) {
                return Int(userId)!
            } else {
                return -1
            }
        case .none:
             print("User id not persisted")
            return -1
        }
    }
}
