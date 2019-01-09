//
//  CTSubscriptionService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation
import RxSwift

/**
 The CTSubscriptionService is the main entry point to fetch subscriptions and start trials for a bike. It allows for convenience methods that get the information required about subscriptions.
 */
public class CTSubscriptionService: NSObject {
    /**
     Fetches all known subscriptions for a bike.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for

     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTSubscriptionModel]> {
        return CTKit.shared.subscriptionManager.getSubscriptionForBike(endpoint: "subscription/bike/\(identifier)")
    }

    /**
     Fetches all known connectivity specific subscriptions for a bike.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     
     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchConnectivitySubscriptions(withbikeId identifier:Int) -> Observable<[CTSubscriptionModel]> {
        return fetchSubscriptionByType(withBikeId: identifier, type: CTSubscriptionService.productTypeConnected)
    }

    /**
     Fetches all known insurance type subscriptions for a bike.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     
     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchInsuranceSubscriptions(withBikeId identifier:Int) -> Observable<[CTSubscriptionModel]> {
        return fetchSubscriptionByType(withBikeId: identifier, type: CTSubscriptionService.productTypeInsured)
    }

    /**
     Fetches all known subscriptions for a bike by type.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     - Parameter type: The type of subcriptions you want to retrieve
     
     - Returns: An observable containing a list of all subscriptions found.
     */
    public func fetchSubscriptionByType(withBikeId identifier:Int, type:Int) -> Observable<[CTSubscriptionModel]> {
        return fetchAll(withBikeId: identifier)
    }

    /**
     Starts a trial for a bike.
     
     - Parameter identifier: The bike identifier you want to start the trial for

     
     - Returns: An observable of the newly started trial.
     */
    public func startTrial(withBikeId identifier: String, type:Int) -> Observable<CTSubscriptionModel> {
        return CTKit.shared.subscriptionManager.startTrial(endpoint: "trial")
    }

    static let productTypeConnected = 1
    static let productTypeInsured = 2
    static let productTypeTrial = 1
}
