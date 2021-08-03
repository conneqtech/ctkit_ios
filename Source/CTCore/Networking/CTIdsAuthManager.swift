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
    
    var refreshingToken = false
    
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
                                                      tokenType: tokenType,
                                                      tokenId: token.idToken)
            
        CTKit.shared.authManager.saveTokenResponse(credentialResponse)
    }
    
    private func getAppAuthLoginRequest(clientId: String, clientSecret: String) -> OIDAuthorizationRequest? {
        
        guard let idsTokenApiUrl = URL(string: "\(self.idsTokenApiUrl)/oauth"),
              let idsLoginApiUrl = URL(string: "\(self.idsLoginApiUrl)/v1/login"),
              let idsRedirectUrl = URL(string: self.idsRedirectUrl) else { return nil }

        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl)

        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientId,
                                              clientSecret: clientSecret,
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
    
    public func login(onViewController viewController: UIViewController, clientId: String, clientSecret: String, callBack: @escaping () -> ()) {
        
        guard let request = CTKit.shared.idsAuthManager?.getAppAuthLoginRequest(clientId: clientId, clientSecret: clientSecret) else { return }
        
        CTKit.shared.idsAuthManager?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            if let authState = authState {

                guard let token = authState.lastTokenResponse else { return }
                CTKit.shared.idsAuthManager?.saveToken(token)
                callBack()
            } else {
                print("Authorization error: \(String(describing: error))")
            }
        }
    }
    
    private func getAppAuthLogoutRequest() -> OIDEndSessionRequest?  {
        
        guard let idsTokenApiUrl = URL(string: "\(self.idsTokenApiUrl)/oauth"),
              let idsLoginApiUrl = URL(string: "\(self.idsTokenApiUrl)/v1/openid/logout"),
              let idsRedirectUrl = URL(string: self.idsRedirectUrl) else { return nil }
        
        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl, issuer: nil,
                                                    registrationEndpoint: nil,
                                                    endSessionEndpoint: idsLoginApiUrl)
        
        let request = OIDEndSessionRequest(configuration: configuration,
                                           idTokenHint: CTKit.shared.authManager.getTokenId(),
                                           postLogoutRedirectURL: idsRedirectUrl,
                                           additionalParameters: nil)
        return request
    }
    
    public func logout(onViewController viewController: UIViewController, callBack: @escaping () -> ()) {
        
        guard let request = CTKit.shared.idsAuthManager?.getAppAuthLogoutRequest(),
              let agent = OIDExternalUserAgentIOS(presenting: viewController) else { return }
        
        CTKit.shared.idsAuthManager?.currentAuthorizationFlow = OIDAuthorizationService.present(request, externalUserAgent: agent) { authState, error in

            if authState != nil {
                HTTPCookieStorage.shared.cookies?.forEach { cookie in
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
                callBack()
            } else {
                print("Logout error: \(String(describing: error))")
            }
        }
    }
}
