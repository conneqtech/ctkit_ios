//
//  CTBaseAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public protocol CTAuthManagerBase {
    func saveTokenResponse(_ tokenResponse: CTOAuth2TokenResponse)
    
    func hasActiveSession() -> Bool

    func getActiveSessionEndDate() -> Date
    func getActiveSessionToken() -> String

    func terminateActiveSession()
}
