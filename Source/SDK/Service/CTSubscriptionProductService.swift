//
//  CTPSubscriptionProductService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/03/2019.
//

import Foundation
import RxSwift

public class CTSubscriptionProductService: NSObject {

    public func fetchAll() -> Observable<[CTSubscriptionProductModel]> {
        return CTKit.shared.subscriptionManager.get(endpoint: "product")
    }

    public func fetchAll(withProductType productType: CTSubscriptionProductType) -> Observable<[CTSubscriptionProductModel]> {
        return self.fetchAll().map { $0.filter { $0.productType ==  productType } }
    }

}
