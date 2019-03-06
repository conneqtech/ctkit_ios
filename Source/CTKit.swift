//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public class CTKit {

    public static var shared: CTKit!

    internal static let ACTIVE_USER_ID_KEY = "activeUserId"
    internal static let ACCESS_TOKEN_KEY = "accessToken"
    internal static let REFRESH_TOKEN_KEY = "refreshToken"

    internal static let ACCESS_TOKEN_EXPIRE_TIME_KEY = "accessTokenExpireDataTime"
    internal static let REFRESH_TOKEN_EXPIRE_TIME_KEY = "refreshTokenExpireDataTime"

    public var restManager: CTRestManager!
    public var authManager: CTAuthManager!
    public var subscriptionManager: CTRestManager!
    public var authToken = ReplaySubject<CTOAuth2TokenResponse>.create(bufferSize: 1)
    public var debugMode: Bool = false

    private var _currentActiveUser: CTUserModel?

    internal var currentActiveUser: CTUserModel? {
        set(newActiveUser) {
            self._currentActiveUser = newActiveUser
            guard let newUser = newActiveUser else {
                return
            }

            //Only save if we have an active user.
            self.saveCurrentActiveUserId(user: newUser)
        }

        get {
            return _currentActiveUser
        }
    }

    internal var currentActiveUserId: Int {
        return getCurrentActiveUserId()
    }

    internal var credentialSaveLocation: CTOAuth2CredentialSaveLocation = .keychain

    private init(clientId: String, clientSecret: String, baseURL: String) {
        let APIConfig = CTApiConfig(withBaseUrl: baseURL,
                                    clientId: clientId,
                                    clientSecret: clientSecret,
                                    grantType: .clientCredentials)

        self.restManager = CTRestManager(withConfig: APIConfig)
        self.authManager = CTAuthManager(withConfig: APIConfig)
    }

    public static func configure(withClientId clientId: String, clientSecret: String, baseURL: String) {
        CTKit.shared = CTKit.init(clientId: clientId, clientSecret: clientSecret, baseURL: baseURL)
    }

    public func addSubscriptions(withClientId clientId: String, clientSecret: String, baseURL: String) {
        let APIConfig = CTVendorApiConfig(
            withBaseUrl: baseURL,
            clientId: clientId,
            clientSecret: clientSecret,
            grantType: .clientCredentials,
            version: "v1",
            vendor: ""
        )

        CTKit.shared.subscriptionManager = CTRestManager(withConfig: APIConfig)
    }
}

internal extension CTKit {
    func logout() {
        currentActiveUser = nil

        KeychainSwift().delete(CTKit.ACTIVE_USER_ID_KEY)
        KeychainSwift().delete(CTKit.ACCESS_TOKEN_KEY)
        KeychainSwift().delete(CTKit.REFRESH_TOKEN_KEY)

        UserDefaults.standard.removeObject(forKey: CTKit.ACTIVE_USER_ID_KEY)
        UserDefaults.standard.removeObject(forKey: CTKit.ACCESS_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: CTKit.REFRESH_TOKEN_KEY)
    }

    func hasActiveSession() -> Bool {
        return currentActiveUserId != -1 && (hasActiveAccessToken() || hasActiveRefreshToken())
    }
}

private extension CTKit {

    func saveCurrentActiveUserId(user: CTUserModel) {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            KeychainSwift().set("\(user.id)", forKey: CTKit.ACTIVE_USER_ID_KEY)
        case .userDefaults:
            UserDefaults.standard.set("\(user.id)", forKey: CTKit.ACTIVE_USER_ID_KEY)
        case .none:
            print("User id not persisted")
        }
    }

    func hasActiveAccessToken() -> Bool {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            return KeychainSwift().get(CTKit.ACCESS_TOKEN_KEY) != nil
        case .userDefaults:
            return UserDefaults.standard.string(forKey: CTKit.ACCESS_TOKEN_KEY) != nil
        case .none:
            return false
        }
    }

    func hasActiveRefreshToken() -> Bool {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            return KeychainSwift().get(CTKit.REFRESH_TOKEN_KEY) != nil
        case .userDefaults:
            return UserDefaults.standard.string(forKey: CTKit.REFRESH_TOKEN_KEY) != nil
        case .none:
            return false
        }
    }

    func getCurrentActiveUserId() -> Int {
        switch CTKit.shared.credentialSaveLocation {
        case .keychain:
            if let userId = KeychainSwift().get(CTKit.ACTIVE_USER_ID_KEY) {
                return Int(userId)!
            } else {
                return -1
            }
        case .userDefaults:
            if let userId = UserDefaults.standard.string(forKey: CTKit.ACTIVE_USER_ID_KEY) {
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
