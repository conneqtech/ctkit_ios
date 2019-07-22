//
//  CTJwtAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTJwtAuthManager: CTAuthManagerBase {
    public func hasActiveSession() -> Bool {
        return true
    }

    public func getActiveSessionEndDate() -> Date {
        return Date()
    }

    public func getActiveSessionToken() -> String {
        return "Fake"
    }

    public func terminateActiveSession() {
        // Terminate here.
    }

    public func saveTokenResponse(_ tokenResponse: CTOAuth2TokenResponse) {

    }
}
