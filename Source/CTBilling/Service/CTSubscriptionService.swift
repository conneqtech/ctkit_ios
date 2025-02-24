//
//  CTSubscriptionService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation
import RxSwift

/**
 The CTSubscriptionService is the main entry point to fetch subscriptions and start trials for a bike.
 It allows for convenience methods that get the information required about subscriptions.
 */
public class CTSubscriptionService: NSObject {

    /**
     Claim the bike in the billing api

     - Parameter identifier: The bike identifier you want to start the trial for


     - Returns: An observable of the newly started subscription (claim)
     */
    public func claim(withBike bike: CTBikeModel) -> Completable {
        if !bike.isRequestingUserOwner {
            return Completable.empty()
        } else {
            return CTKit.shared.restManager.postCompletable(endpoint: "v1/tools/start-all-in-period", parameters: [
                "bike_id": bike.id
            ])
        }
    }
    
    public func fetchSubscriptions(withBikeId identifier: Int) -> Observable<[CTSubscriptionModel]>{
        return CTBilling.shared.restManager.get(endpoint: "subscription/bike/\(identifier)/product-type", error, reportableService: true)
    }
}
