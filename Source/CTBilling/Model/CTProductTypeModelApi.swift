//
//  CTProductTypeModelApi.swift
//  ctkit
//
//  Created by Inigo Llamosas on 25/01/2021.
//

import Foundation
import RxSwift

class CTProductTypeModelApi: NSObject {

    public static let shared: CTProductTypeModelApi = CTProductTypeModelApi()
    
    func fetchProducts(withBikeId identifier: Int) -> Observable<[CTProductTypeModel]>{
        return CTBilling.shared.restManager.get(endpoint: "subscription/bike/\(identifier)/product-type")
    }

    func fetchInsuranceProducts(withBikeId identifier: Int) -> Observable<[CTProductTypeModel]> {
        return fetchProductsByType(withBikeId: identifier, type: .insurance)
    }

    func fetchProductsByType(withBikeId identifier: Int, type: CTSubscriptionProductType) -> Observable<[CTProductTypeModel]> {
        return fetchProducts(withBikeId: identifier).map { subscription in
            subscription.filter { $0.productTypeId == type && $0.active }
        }
    }
}
