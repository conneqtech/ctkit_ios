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
    var idsRedirectUrl = ""
    
    public init(idsTokenApiUrl: String, idsLoginApiUrl: String, idsRedirectUri: String) {
        self.idsTokenApiUrl = idsTokenApiUrl
        self.idsLoginApiUrl = idsLoginApiUrl
        self.idsRedirectUrl = idsRedirectUri
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
    
    public func getAppAuthLoginRequest(clientId: String) -> OIDAuthorizationRequest? {
        
        guard let idsTokenApiUrl = URL(string: "\(self.idsTokenApiUrl)/oauth"),
              let idsLoginApiUrl = URL(string: "\(self.idsLoginApiUrl)/v1/login"),
              let idsRedirectUrl = URL(string: self.idsRedirectUrl) else { return nil }

        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl)

        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientId,
                                              clientSecret: nil,
                                              scope: "openid profile",
                                              redirectURL: idsRedirectUrl,
                                              responseType: OIDResponseTypeCode,
                                              state: nil,
                                              nonce: nil,
                                              codeVerifier: nil,
                                              codeChallenge: nil,
                                              codeChallengeMethod: nil,
                                              additionalParameters: nil)

        return request
    }
    
    public func getAppAuthLogoutRequest(clientId: String) -> OIDAuthorizationRequest? {
        
        guard let idsTokenApiUrl = URL(string: "\(self.idsTokenApiUrl)/oauth"),
              let idsLoginApiUrl = URL(string: "\(self.idsLoginApiUrl)/v1/login"),
              let idsRedirectUrl = URL(string: self.idsRedirectUrl) else { return nil }

        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl)

        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientId,
                                              clientSecret: nil,
                                              scope: "openid offline_access",
                                              redirectURL: idsRedirectUrl,
                                              responseType: OIDResponseTypeCode,
                                              state: nil,
                                              nonce: nil,
                                              codeVerifier: nil,
                                              codeChallenge: nil,
                                              codeChallengeMethod: nil,
                                              additionalParameters: nil)

        return request
    }
}
