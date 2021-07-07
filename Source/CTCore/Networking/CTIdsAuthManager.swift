//
//  CTIdsAuthManager.swift
//  ctkit
//
//  Created by Inigo Llamosas on 09/04/2021.
//

import Foundation
import Alamofire
import RxSwift
import AppAuth

public class CTIdsAuthManager: NSObject {

    public var currentAuthorizationFlow: OIDExternalUserAgentSession? = nil
    var idsTokenApiUrl = ""
    var idsLoginApiUrl = ""
    var idsRedirectUri = ""
    
    public init(idsTokenApiUrl: String, idsLoginApiUrl: String, idsRedirectUri: String) {
        self.idsTokenApiUrl = idsTokenApiUrl
        self.idsLoginApiUrl = idsLoginApiUrl
        self.idsRedirectUri = idsRedirectUri
    }
    
    public func saveToken(_ token: OIDTokenResponse) {

        guard let tokenType = token.tokenType,
              let accessToken = token.accessToken,
              let expirationDate = token.accessTokenExpirationDate,
              let tokenType = token.tokenType else { return }
        
        let credentialResponse = CTCredentialResponse(accessToken: accessToken,
                                                      refreshToken: token.refreshToken,
                                                      expiresIn: Int(expirationDate.timeIntervalSince(Date())),
                                                      scope: token.scope,
                                                      tokenType: tokenType)
            
        CTKit.shared.authManager.saveTokenResponse(credentialResponse)
    }
}
