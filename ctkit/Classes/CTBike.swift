//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation

public class CTBike {
    
    public static var shared:CTBike!
    public var credentialSaveLocation: CTOAuth2CredentialSaveLocation = .keychain
    
    public var restManager: CTRestManager!
    public var authManager: CTAuthManager!
    
    private init(clientId: String, clientSecret: String, baseURL: String) {
        let APIConfig = CTApiConfig(withBaseUrl: baseURL,
                                    clientId: clientId,
                                    clientSecret: clientSecret,
                                    grantType: .clientCredentials)
        
        self.restManager = CTRestManager(withConfig: APIConfig)
        self.authManager = CTAuthManager(withConfig: APIConfig)
    }
    
    public static func configure(withClientId clientId: String, clientSecret: String, baseURL: String) {
        CTBike.shared = CTBike.init(clientId: clientId, clientSecret: clientSecret, baseURL: baseURL)
    }
}
