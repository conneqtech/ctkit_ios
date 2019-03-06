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
     Fetches all known active subscriptions for a bike.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for

     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTSubscriptionModel]> {
        return CTKit.shared.subscriptionManager.get(endpoint: "subscription/bike/\(identifier)")
    }
    
    
    /**
     Fetches all known subscriptions for a bike with the connectivity type.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     
     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchConnectivitySubscriptions(withBikeId identifier: Int) -> Observable<[CTSubscriptionModel]> {
        return fetchByType(withBikeId: identifier, type: .connectivity)
    }
    
    /**
     Fetches all known subscriptions for a bike with the insurance type.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     
     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchInsuranceSubscriptions(withBikeId identifier: Int) -> Observable<[CTSubscriptionModel]> {
        return fetchByType(withBikeId: identifier, type: .insurance)
    }

    /**
     Starts a trial for a bike.
     
     - Parameter identifier: The bike identifier you want to start the trial for

     
     - Returns: An observable of the newly started trial.
     */
    public func startTrial(withBikeId identifier: Int, imei: String) -> Observable<CTSubscriptionModel> {
        return CTKit.shared.subscriptionManager.post(endpoint: "trial", parameters: [
            "bike_id": identifier,
            "hash": imei
            ]
        )
    }
    
    // Private API.
    private func fetchByType(withBikeId identifier: Int, type: CTSubscriptionProductType) -> Observable<[CTSubscriptionModel]> {
        return fetchAll(withBikeId: identifier).map { subscription in
            subscription.filter { $0.type == type }
        }
    }
}
