//
//  CTProductTypeModelApi.swift
//  ctkit
//
//  Created by Inigo Llamosas on 25/01/2021.
//

import Foundation
import RxSwift

public class CTProductTypeModelApi {

    public static let shared: CTProductTypeModelApi = CTProductTypeModelApi()
    
    public func fetchProducts(withBikeId identifier: Int) -> Observable<[CTProductTypeModel]>{
        return CTBilling.shared.restManager.get(endpoint: "subscription/bike/\(identifier)/product-type")
    }

    public func fetchInsuranceProducts(withBikeId identifier: Int) -> Observable<[CTProductTypeModel]> {
        return self.fetchProducts(withBikeId: identifier).map { product in
            product.filter({ $0.productTypeId == .insurance && $0.active })
        }
    }
}
