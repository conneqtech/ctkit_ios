//
//  CTIdsAuthManager.swift
//  ctkit
//
//  Created by Inigo Llamosas on 09/04/2021.
//

import Foundation
import Alamofire
import RxSwift

public class CTIdsAuthManager: NSObject {

    public let state = UUID().uuidString
    
    
    public func createRedirectUrl(idsLoginAPI: String, clientId: String, locale: String) -> URL? {

        let queryItems = [URLQueryItem(name: "client_id", value: clientId), URLQueryItem(name: "redirect_uri", value: "https://app.conneq.tech"), URLQueryItem(name: "state", value: self.state), URLQueryItem(name: "locale", value: locale)]
        if var urlComps = URLComponents(string: "\(idsLoginAPI)/login") {
            urlComps.queryItems = queryItems
            return urlComps.url
        }
        return nil
    }
    
    public func getClientToken(authorizationCode: String, idsTokenApiUrl: URL, callBack: @escaping (() -> ())) {

        let requestReference = Alamofire.request(idsTokenApiUrl,
                                                 method: .post,
                                                 parameters: [
                                                    "grant_type": "authorization_code",
                                                    "client_id": CTKit.shared.authManager.apiConfig.clientId,
                                                    "client_secret": CTKit.shared.authManager.apiConfig.clientSecret,
                                                    "code": authorizationCode,
                                                    "redirect_uri": "https://app.conneq.tech"])
        .validate()
        .responseJSON { (response) in
            switch response.result {
                case .success:
                    guard let data = response.data,
                          let getResponse = try? JSONDecoder().decode(CTCredentialResponse.self, from: data) else {
                        return
                    }
                    CTKit.shared.authManager.saveTokenResponse(getResponse)
                    callBack()
                case .failure:
                    print("Error: \(response)")
            }
        }
    }
}
