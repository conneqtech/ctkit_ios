//
//  CTJwtService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/07/2019.
//

import Foundation
import RxSwift

public class CTJwtService: NSObject {
    func getJwtForActivityCenter() -> Observable<String> {
        return CTKit.shared.restManager.get(endpoint: "jwt/activitycenter").map { (dict: [String:String]) in
            return dict["token"]!}
    }
    
    func getJwtForContentAPI() -> Observable<String> {
        return CTKit.shared.restManager.get(endpoint: "jwt/contentapi").map { (dict: [String:String]) in
            return dict["token"]!}
    }

    public func getJwtForWebSubscriptions(url: String) -> Observable<CTOnlineSubscriptionsTokenResponse> {
        let additionalHeaders: [String: String] = ["X-Original-URI": url,
                                                  "Accept": "application/json",
                                                  "X-Token-Lifetime": "600"]
        let token = CTKit.shared.authManager.getActiveSessionToken()
        return CTKit.shared.restManager.getGenericUrl(url: url, useToken: token, additionalHeaders: additionalHeaders)
    }
}
