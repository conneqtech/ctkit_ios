//
//  CTJwtAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public class CTJwtAuthManager: CTAuthManagerBase {

    var activeToken: String = ""
    
    public func hasActiveSession() -> Bool {
        return activeToken != ""
    }

    public func getActiveSessionEndDate() -> Date {
        return Date()
    }

    public func getActiveSessionToken() -> String {
        return activeToken
    }

    public func terminateActiveSession() {
        // Terminate here.
        activeToken = ""
    }

    public func saveTokenResponse(_ tokenResponse: CTCredentialResponse) {
        activeToken = tokenResponse.accessToken
    }
}
