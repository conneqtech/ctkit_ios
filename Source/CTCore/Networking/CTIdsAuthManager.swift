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

    private var authState: OIDAuthState?
    public var currentAuthorizationFlow: OIDExternalUserAgentSession? = nil
    
    public let state = UUID().uuidString
    
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
    
    public func createRedirectUrl(clientId: String) -> URL? {
        

        
        guard let regionCode = Locale.current.regionCode,
              let languageCode = Locale.current.languageCode else { return nil }
        
        let locale = "\(languageCode)_\(regionCode)"
        
        let queryItems = [URLQueryItem(name: "client_id", value: clientId), URLQueryItem(name: "redirect_uri", value: self.idsRedirectUri), URLQueryItem(name: "state", value: self.state), URLQueryItem(name: "locale", value: locale)]
        if var urlComps = URLComponents(string: "\(self.idsLoginApiUrl)/login") {
            urlComps.queryItems = queryItems
            return urlComps.url
        }
        return nil
    }
    
    public func login(authorizationCode: String) -> Observable<Any> {

        let parameters = ["grant_type": "authorization_code",
                          "client_id": CTKit.shared.authManager.apiConfig.clientId,
                          "client_secret": CTKit.shared.authManager.apiConfig.clientSecret,
                          "code": authorizationCode,
                          "redirect_uri": self.idsRedirectUri]
        
        return CTKit.shared.authManager.login(url: self.idsTokenApiUrl, parameters: parameters)
    }
}
