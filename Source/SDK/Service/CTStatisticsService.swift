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
    
    /**
     Fetch statistics for a bike with a type, start and end date. When you don't specify a timezone the current timezone of the device will be used.
     
     type can be one of : 'hourly', 'daily' or 'monthly'
     tz should be a valid zoneinfo location e.g. 'Europe/Amsterdam', 'America/New_York'
     tz is used for division of the type, so the daily starts at midnight in the given tz
     
     for type 'hourly' no more than 7 days can be between 'from' and 'till'
     for type 'daily' no more than 90 days can be between 'from' and 'till'
     
     for type 'hourly' the 'from' should be less than 1 year in the past
     
     - parameter identifier: The id of the bike you want statistics for
     - parameter type: Can be hourly, daily or monthly
     - parameter from: The start date (including time) you want statistics for. Keep in mind the above limitations
     - parameter till: The end date (including time) you want statistics for. Keep in mind the above limitations
     */
    public func fetchAll(withBikeId identifier: Int,
                         type: String,
                         from: Date,
                         till: Date) -> Observable<[CTStatisticsModel]> {
        let parameters = [
            "type": type,
            "from": from.toAPIDate(),
            "till": till.toAPIDate(),
            "tz": NSTimeZone.system.identifier
        ]
        
        print(parameters)
    
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/stats", parameters: parameters)
    }
}
