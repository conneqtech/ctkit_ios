//
//  CTNewSubscriptionService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation
import RxSwift

public class CTNewSubscriptionService: NSObject {

    fileprivate func fetchSubscriptionWrappers(url: String, token: String, headers: [String: String] = [:]) -> Observable<[CTNewSubscriptionWrapperModel]> {
        return CTKit.shared.restManager.getGenericUrl(url: url, useToken: token, additionalHeaders: headers, reportableService: true)
    }

    public func fetchSubscriptions(imei: String, url: String, token: String, headers: [String: String] = [:]) -> Observable<[CTNewSubscriptionModel]> {
    
        return self.fetchSubscriptionWrappers(url: url, token: token, headers: headers).map { result in
            var allSubscriptions: [CTNewSubscriptionModel] = []
            for sub in result {
                if let s = sub.status {
                    s.imei = imei
                    allSubscriptions.append(s)
                }
            }
            return allSubscriptions
        }
    }
}
