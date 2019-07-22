//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTBilling {
    public static func configure(withClientId clientId: String, clientSecret: String, baseURL: String) {
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
