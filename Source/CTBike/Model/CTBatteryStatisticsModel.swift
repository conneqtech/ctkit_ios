//
//  CTBatteryStatisticsService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 06/09/2019.
//

import Foundation

public struct CTBatteryStatisticsModel: CTBaseModel {
    public let date: Date
    public let batteryPercentage: Int?
    public let charging:Bool
    public let secondsInRide: Int
    public let secondsCharging: Int


    enum CodingKeys: String, CodingKey {
        case date
        case batteryPercentage = "battery_percentage"
        case charging
        case secondsInRide = "seconds_in_ride"
        case secondsCharging = "seconds_charging"
    }

    public init(date: Date, batteryPercentage: Int, charging: Bool, secondsInRide: Int, secondsCharging: Int) {
        self.date = date
        self.batteryPercentage = batteryPercentage
        self.charging = charging
        self.secondsInRide = secondsInRide
        self.secondsCharging = secondsCharging
    }
}
