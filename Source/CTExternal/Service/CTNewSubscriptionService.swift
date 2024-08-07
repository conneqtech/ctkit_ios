//
//  CTNewSubscriptionService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation
import RxSwift

public class CTNewSubscriptionService: NSObject {
    public func fetchSubscriptions(url: String, token: String, headers: [String: String] = [:]) -> Observable<[CTNewSubscriptionWrapperModel]> {
        return CTKit.shared.restManager.getGenericUrl(url: url, useToken: token, additionalHeaders: headers)
    }
}
