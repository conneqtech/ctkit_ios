//
//  CTCurrentBatteryStateModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/09/2019.
//

import Foundation

public struct CTCurrentBatteryStateModel: CTBaseModel {
    public let current: Int?
    public let batteryPercentage: Int?
    public let lastBatteryUpdateDate: Date?
    public let lastFullChargeDate: Date?
    public let isCharging: Bool?
    public let range:Int?
    public let fullChargeIndication: Date?
    
    public init(
        current: Int? = nil,
        batteryPercentage: Int? = nil,
        lastBatteryUpdateDate: Date? = nil,
        lastFullChargeDate: Date? = nil,
        isCharging: Bool? = nil,
        range: Int? = nil,
        fullChargeIndication: Date? = nil) {
        
        self.current = current
        self.batteryPercentage = batteryPercentage
        self.lastBatteryUpdateDate = lastBatteryUpdateDate
        self.lastFullChargeDate = lastFullChargeDate
        self.isCharging = isCharging
        self.range = range
        self.fullChargeIndication = fullChargeIndication
    }

    enum CodingKeys: String, CodingKey {
        case current
        case batteryPercentage = "battery_percentage"
        case lastBatteryUpdateDate = "last_battery_update"
        case lastFullChargeDate = "last_full_charge"
        case isCharging = "charging"
        case range
        case fullChargeIndication = "full_charge_indication"
    }
}
