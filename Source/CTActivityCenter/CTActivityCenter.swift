//
//  CTActivityCenter.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTActivityCenter:CTKitBase {
    public static var shared: CTActivityCenter!

    public var restManager: CTRestManager!
    public var authManager: CTAuthManagerBase!

    public var isConfigured = false

    private init(withBaseURL baseURL: String) {
        let APIConfig = CTJwtApiConfig(
            withBaseUrl: baseURL
        )

        self.restManager = CTRestManager(withConfig: APIConfig,
                                         requestAdapter: CTActivityCenterRequestAdapter(),
                                         requestRetrier: CTActivityCenterRequestRetrier(apiConfig: APIConfig))
        self.authManager = CTJwtAuthManager()
        self.isConfigured = true
    }

    public static func configure(withBaseURL baseURL: String) {
        CTActivityCenter.shared = CTActivityCenter.init(withBaseURL: baseURL)
    }

    public func hasActiveSession() -> Bool {
        return false
    }

    public func getActiveSessionEndDate() -> Date {
        return Date()
    }
    
    public func terminateActiveSession() {
        // Kill session
    }
}
