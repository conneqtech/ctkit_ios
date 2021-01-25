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
     Starts a trial for a bike.
     
     - Parameter identifier: The bike identifier you want to start the trial for

     
     - Returns: An observable of the newly started trial.
     */
    @available(*, deprecated, message: "Please use claim(_, _) instead")
    public func startTrial(withBikeId identifier: Int, imei: String) -> Observable<CTSubscriptionModel> {
        return CTBilling.shared.restManager.post(endpoint: "trial", parameters: [
            "bike_id": identifier,
            "hash": imei
            ]
        )
    }

    /**
     Claim the bike in the billing api

     - Parameter identifier: The bike identifier you want to start the trial for


     - Returns: An observable of the newly started subscription (claim)
     */
    public func claim(withBike bike: CTBikeModel) -> Observable<CTSubscriptionModel> {

        if !bike.isRequestingUserOwner {
            return CTSubscriptionModel.mockSubscription()
        } else {
            return CTBilling.shared.restManager.post(endpoint: "claim", parameters: [
                "bike_id": bike.id,
                "hash": bike.imei
                ]
            )
        }
    }
}
