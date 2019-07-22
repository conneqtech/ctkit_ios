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
    public var authManager: CTAuthManager!

    private init(withBaseURL baseURL: String) {
        let APIConfig = CTJwtApiConfig(
            withBaseUrl: baseURL
        )

        self.restManager = CTRestManager(withConfig: APIConfig)
        self.authManager = CTAuthManager(withConfig: APIConfig)
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

    public func getActiveSessionToken() -> String {
        return "FAKE"
    }

    public func terminateActiveSession() {
        // Kill session
    }
}
