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
    
    public func getJwtForOnlineSubscriptions(url: String, useToken: String, additionalHeaders: [String: String]) -> Observable<CTOnlineSubscriptionsTokenResponse> {
        return CTKit.shared.restManager.getGenericUrl(url: url, useToken: useToken, additionalHeaders: additionalHeaders)
    }
}
