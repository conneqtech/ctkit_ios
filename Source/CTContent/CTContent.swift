//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTContent: CTKitBase {
    public static var shared: CTContent!

    public var restManager: CTRestManager
    public var authManager: CTAuthManagerBase

    public var isConfigured = false

    private init(withBaseURL baseURL: String) {
        let APIConfig = CTJwtApiConfig(
            withBaseUrl: baseURL
        )

        self.restManager = CTRestManager(withConfig: APIConfig,
                                         requestAdapter: CTContentRequestAdapter(),
                                         requestRetrier: CTContentRequestRetrier())
        self.authManager = CTJwtAuthManager()
        self.isConfigured = true
    }

    public static func configure(withBaseURL baseURL: String) {
        CTContent.shared = CTContent.init(withBaseURL: baseURL)
    }
}
