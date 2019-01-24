//
//  CTStatisticsService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

/**
 The CTStatisticService is the main entry point for some basic statistics about the bike. This service will be expanded once their is more (fine grained) information to share
 */
public class CTStatisticsService: NSObject {

    /**
     Fetch the last 7 days of statistics for a bike
     
     - Parameter identifier: The identifier of the bike you want to fetch the statistics for
     
     - Returns: An observable containing an array of 7 items, one for each day.
     */
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTStatisticsModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/stats")
    }

    /**
     Fetch the hourly statistics for a bike
     
     - Parameter identifier: The identifier of the bike you want to fetch the hourly statistics for
     
     - Returns: And observable containing the hourly statistics for the bike.
    */
    public func fetchAll(withBikeId identifier: Int, after: Date) -> Observable<[CTStatisticsModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/stats", parameters: [
            "type": "hourly",
            "from": after.toAPIDate()])
    }
}
