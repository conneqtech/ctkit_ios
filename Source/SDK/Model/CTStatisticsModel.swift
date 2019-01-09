//
//  CTStatisticsModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTStatisticsModel:CTBaseModel {
    public let from:Date
    public let till:Date
    // swiftlint:disable:next identifier_name
    public let co2:Int
    public let calories:Int
    public let avg_speed:Int
    public let distance_traveled:Int

    enum CodingKeys: String, CodingKey {
        case from = "from"
        case till = "till"
        case co2 = "co2"
        case calories = "calories"
        case avg_speed = "avg_speed"
        case distance_traveled = "distance_traveled"
    }
}
