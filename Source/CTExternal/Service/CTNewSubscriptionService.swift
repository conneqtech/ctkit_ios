//
//  CTNewSubscriptionService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation
import RxSwift



public class CTNewSubscriptionService: NSObject {

    public func fetchSubscriptions(forImei: String) -> Observable<[CTNewSubscriptionModel]>{
        
        CTKit.shared.restManager.get(endpoint: <#T##String#>)
        
        
        return CTBilling.shared.restManager.get(endpoint: "subscription/bike/\(identifier)/product-type")
    }
}
