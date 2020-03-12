//
//  CTStatisticsModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTStatisticsModel: CTBaseModel {
    public let from: Date
    public let till: Date
    public let co2: Int
    public let calories: Int
    public let averageSpeed: Int
    public let distanceTraveled: Int
    public let topSpeed: Int

    enum CodingKeys: String, CodingKey {
        case from
        case till
        case co2 = "c02"
        case calories
        case averageSpeed = "avg_speed"
        case distanceTraveled = "distance_traveled"
        case topSpeed = "top_speed"
    }

    public init(withFrom from: Date, till: Date) {
        self.from = from
        self.till = till
        self.co2 = -1
        self.calories = -1
        self.averageSpeed = -1
        self.distanceTraveled = -1
        self.topSpeed = -1
    }
}
