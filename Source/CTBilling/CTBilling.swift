//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTBilling: CTKitBase {
    public static var shared: CTBilling!

    public var restManager: CTRestManager
    public var authManager: CTAuthManagerBase

    public var isConfigured = false

    private init(withClientId clientId: String, clientSecret: String, baseURL: String) {
        let APIConfig = CTVendorApiConfig(
            withBaseUrl: baseURL,
            clientId: clientId,
            clientSecret: clientSecret,
            grantType: .clientCredentials,
            version: "v1",
            vendor: ""
        )

        self.restManager = CTRestManager(withConfig: APIConfig)
        self.authManager = CTAuthManager(withConfig: APIConfig)
        
        self.isConfigured = true
    }

    public static func configure(withClientId clientId: String, clientSecret: String, baseURL: String) {
        CTBilling.shared = CTBilling.init(withClientId: clientId, clientSecret: clientSecret, baseURL: baseURL)
    }
}
