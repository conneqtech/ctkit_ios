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
        return CTKit.shared.subscriptionManager.get(endpoint: "subscription/bike/\(identifier)")
    }
    
    /**
     Starts a trial for a bike.
     
     - Parameter identifier: The bike identifier you want to start the trial for

     
     - Returns: An observable of the newly started trial.
     */
    public func startTrial(withBikeId identifier: String, imei: String) -> Observable<CTSubscriptionModel> {
        return CTKit.shared.subscriptionManager.post(endpoint: "trial", parameters: [
            "bike_id": identifier,
            "imei": imei,
            "product_id":0]
        )
    }

    static let productTypeConnected = 1
    static let productTypeInsured = 2
    static let productTypeTrial = 1
}
