//
//  CTStatisticsService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift
import SwiftDate

public enum CTStatisticsInterval: String {
    case hourly
    case daily
    case monthly
}

public struct CTCalculatedStatisticsModel {
    public var caloriesAverage:Int
    public var caloriesTop:Int

    public var co2Average: Int
    public var co2Top: Int

    public var speedAverage:Int
    public var speedTop: Int

    public var distanceAverage: Int
    public var distanceTop: Int
}

/**
 The CTStatisticService is the main entry point for some basic statistics about the bike. This service will be expanded once their is more (fine grained) information to share
 */
public class CTStatisticsService: NSObject {

    public override init() {
        super.init()
        SwiftDate.defaultRegion = Region(calendar: Calendar(identifier: .iso8601) , zone: NSTimeZone.system, locale: Locale.current)
    }

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
     Fetch statistics for a bike with a type, start and end date. The timezone of the device will be used
     
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

        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/stats", parameters: parameters)
    }

    /**
    Fetch statistics for a bike with a type, start and end date. The timezone of the device will be used

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
                         type: CTStatisticsInterval,
                         from: Date,
                         till: Date) -> Observable<[CTStatisticsModel]> {
        let parameters: [String:Any] = [
            "type": type,
            "from": from.toAPIDate(),
            "till": till.toAPIDate(),
            "tz": NSTimeZone.system.identifier
        ]

        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/stats", parameters: parameters)
    }

//    public func fetchWeek(withBikeId identifier: Int, andDayInWeek statsDay: Date) -> Observable<[CTStatisticsModel]> {
//
//        return fetchAll(withBikeId: identifier, type: "daily", from: statsDay.dateAtStartOf(.weekOfYear), till: statsDay.dateAtEndOf(.weekOfYear))
//    }
//
//    public func fetchDay(withBikeId identifier: Int, andDay statsDay: Date) -> Observable<[CTStatisticsModel]> {
//        return fetchAll(withBikeId: identifier, type: .hourly, from: statsDay.startOfDay(), till: statsDay.endOfDay())
//    }

//    public func determinAverageAndTop(forStatistics stats: [CTStatisticsModel]) -> CTCalculatedStatisticsModel {
//        var caloriesTotal: Int = 0
//        var co2Total: Int = 0
//        var speedTotal:Int = 0
//        var distanceTotal:Int = 0
//
//        stats.forEach {
//            caloriesTotal += $0.calories
//            co2Total += $0.co2
//            speedTotal += $0.averageSpeed
//            distanceTotal += $0.distanceTraveled
//        }
//
//        return CTCalculatedStatisticsModel(caloriesAverage: Int(caloriesTotal / stats.count),
//                                           caloriesTop: 0,
//                                           co2Average: Int(co2Total / stats.count),
//                                           co2Top: 0,
//                                           speedAverage: Int(speedTotal / stats.count),
//                                           speedTop: 0,
//                                           distanceAverage: Int(distanceTotal / stats.count),
//                                           distanceTop: 0
//        )
//    }
}
