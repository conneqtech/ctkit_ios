//
//  CTCurrentBatteryStateModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/09/2019.
//

import Foundation

struct CTCurrentBatteryStateModel: CTBaseModel {

    public let current: Int?
    public let batteryPercentage: Int?
    public let lastBatteryUpdateDate: Date?
    public let lastFullChargeDate: Date?
    public let isCharging: Bool?
    public let range:Int?

    enum CodingKeys: String, CodingKey {
        case current
        case batteryPercentage = "battery_percentage"
        case lastBatteryUpdateDate = "last_battery_update"
        case lastFullChargeDate = "last_full_charge"
        case isCharging = "charging"
        case range
    }
}
