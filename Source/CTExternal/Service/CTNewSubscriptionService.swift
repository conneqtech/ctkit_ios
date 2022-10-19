//
//  CTNewSubscriptionService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation
import RxSwift


public class CTNewSubscriptionService: NSObject {
    public func fetchSubscriptions(url: String, token: String) -> Observable<[CTNewSubscriptionModel]> {
        return CTKit.shared.restManager.getGenericUrl(url: url, useToken: token)
    }
}
