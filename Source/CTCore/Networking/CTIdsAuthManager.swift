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
              let expirationDate = token.accessTokenExpirationDate else { return }
        
        let credentialResponse = CTCredentialResponse(accessToken: accessToken,
                                                      refreshToken: token.refreshToken,
                                                      expiresIn: Int(expirationDate.timeIntervalSince(Date())),
                                                      scope: token.scope,
                                                      tokenType: tokenType,
                                                      tokenId: token.idToken)
            
        CTKit.shared.authManager.saveTokenResponse(credentialResponse)
    }
    
    fileprivate func getAppAuthLoginRequest(clientId: String, clientSecret: String) -> OIDAuthorizationRequest? {

        guard let idsTokenApiUrlString = CTKit.shared.idsAuthManager?.idsTokenApiUrl,
              let idsTokenApiUrl = URL(string: "\(idsTokenApiUrlString)/oauth"),
              let idsLoginApiUrlString = CTKit.shared.idsAuthManager?.idsLoginApiUrl,
              let idsLoginApiUrl = URL(string: "\(idsLoginApiUrlString)/v1/login"),
              let idsRedirectUrlString = CTKit.shared.idsAuthManager?.idsRedirectUrl,
              let idsRedirectUrl = URL(string: idsRedirectUrlString) else { return nil }
        
        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl)

        // builds authentication request
        let request =  OIDAuthorizationRequest(configuration: configuration,
                                               clientId: clientId,
                                               clientSecret: clientSecret,
                                               scopes: [OIDScopeOpenID, OIDScopeProfile],
                                               redirectURL: idsRedirectUrl,
                                               responseType: OIDResponseTypeCode,
                                               additionalParameters: nil)
        request.setValue(nil, forKey: "nonce")
        return request
    }
    
    public func login(onViewController viewController: UIViewController, clientId: String, clientSecret: String, callBack: @escaping (Error?) -> ()) {
        
        guard let request = CTKit.shared.idsAuthManager?.getAppAuthLoginRequest(clientId: clientId, clientSecret: clientSecret) else { return }

        CTKit.shared.idsAuthManager?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { optionalAuthState, optionalError in
            if let authState = optionalAuthState,
               let token = authState.lastTokenResponse, optionalError == nil {
                CTKit.shared.idsAuthManager?.saveToken(token)
                callBack(nil)
            } else {
                let error = optionalError ?? NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "authState and/or authState.lastTokenResponse are nil"])
                print("Authorization error: \(String(describing: error))")
                callBack(error)
            }
        }
    }
    
    fileprivate func getAppAuthLogoutRequest(callBack: @escaping (OIDEndSessionRequest?) -> ())  {
        CTKit.shared.idsAuthManager?.getTokenIdForLogout(callBack: { _ in
            guard let request = CTKit.shared.idsAuthManager?.getOIDEndSessionRequestForLogout() else { return }
            callBack(request)
        })
    }
    
    func getTokenIdForLogout(callBack: @escaping (Bool) -> ()) {

        let tokenId = CTKit.shared.authManager.getTokenId()
        if tokenId != "" {

            callBack(true)
            return
        }

        guard let idsTokenApiUrlString = CTKit.shared.idsAuthManager?.idsTokenApiUrl else { return }

        CTKit.shared.authManager.refreshTokens(url: idsTokenApiUrlString) { succeeded, tokenResponse in

            if succeeded, let tokenResponse = tokenResponse {
                CTKit.shared.authManager.saveTokenResponse(tokenResponse)
            }
            callBack(false)
        }
    }
    
    fileprivate func getOIDEndSessionRequestForLogout() -> OIDEndSessionRequest? {
        
        let tokenId = CTKit.shared.authManager.getTokenId()
        guard let idsTokenApiUrlString = CTKit.shared.idsAuthManager?.idsTokenApiUrl,
              let idsTokenApiUrl = URL(string: "\(idsTokenApiUrlString)/oauth"),
              let idsLoginApiUrl = URL(string: "\(idsTokenApiUrlString)/v1/openid/logout"),
              let idsRedirectUrlString = CTKit.shared.idsAuthManager?.idsRedirectUrl,
              let idsRedirectUrl = URL(string: idsRedirectUrlString) else { return nil }

        let configuration = OIDServiceConfiguration(authorizationEndpoint: idsLoginApiUrl,
                                                    tokenEndpoint: idsTokenApiUrl,
                                                    issuer: nil,
                                                    registrationEndpoint: nil,
                                                    endSessionEndpoint: idsLoginApiUrl)
        
        return OIDEndSessionRequest(configuration: configuration,
                                    idTokenHint: tokenId,
                                    postLogoutRedirectURL: idsRedirectUrl,
                                    additionalParameters: nil)
    }
    
    public func logout(onViewController viewController: UIViewController, callBack: @escaping () -> ()) {
        
        guard let agent = OIDExternalUserAgentIOS(presenting: viewController) else { return }
        
        CTKit.shared.idsAuthManager?.getAppAuthLogoutRequest(callBack: { optRequest in
            
            guard let request = optRequest else { return }

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
        })
    }
}
