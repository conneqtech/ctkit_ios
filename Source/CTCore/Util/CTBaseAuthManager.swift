//
//  CTBaseAuthManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation

public protocol CTAuthManagerBase {
    func saveTokenResponse(_ tokenResponse: CTCredetialResponse)
    
    func hasActiveSession() -> Bool

    func getActiveSessionEndDate() -> Date
    func getActiveSessionToken() -> String

    func terminateActiveSession()
}
