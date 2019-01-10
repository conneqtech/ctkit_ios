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
    public let co2:Int
    public let calories:Int
    public let averageSpeed:Int
    public let distanceTraveled:Int

    enum CodingKeys: String, CodingKey {
        case from
        case till
        case co2
        case calories
        case averageSpeed = "avg_speed"
        case distanceTraveled = "distance_traveled"
    }
}
