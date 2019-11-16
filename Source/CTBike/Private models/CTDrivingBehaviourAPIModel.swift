//
//  CTDrivingBehaviourAPIModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation

public enum CTWeeklyReportGrouping: String, Codable {
    // time_of_day types
    case morning
    case afternoon
    case evening
    case night
    
    //day_of_week types
    case monday     = "1"
    case tuesday    = "2"
    case wednesday  = "3"
    case thursday   = "4"
    case friday     = "5"
    case saturday   = "6"
    case sunday     = "0"
}

public enum CTWeeklyReportGroupingType: String, Codable {
    case timeOfDay = "time_of_day"
    case dayOfWeek = "day_of_week"
}

struct CTDrivingBehaviourAPIModel: CTBaseModel {

    var caloriesBurned: Int
    var averageSpeed: Int
    var carbonDioxide: Int
    var numRides: Int
    var grouping: CTWeeklyReportGrouping
    var groupingType: CTWeeklyReportGroupingType
    var distance: Int
    var averagePowerDistribution: Int
    var shiftAdvice: Int

    enum CodingKeys: String, CodingKey {
        case caloriesBurned = "calories"
        case averageSpeed
        case carbonDioxide = "carbon_dioxide"
        case numRides = "num_rides"
        case grouping
        case groupingType = "grouping_type"
        case distance
        case averagePowerDistribution = "avg_power_distribution"
        case shiftAdvice = "shift_advice"
    }
}
