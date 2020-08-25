//
//  CTBikeStateModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/06/2019.
//

import Foundation

public struct CTBikeStateModel: CTBaseModel {
    
    public let isPoweredOn: Bool?
    public let isDigitalLockLocked: Bool?
    public let isPhysicalLockLocked: Bool?
    
    public let batteryPercentage: Int?
    public let isCharging: Bool?
    public let lastFullChargeDate: Date?
    public let range: Int?
    public let odometer: Int?
    
    enum CodingKeys: String, CodingKey {
        case isPoweredOn = "powered_on"
        case isDigitalLockLocked = "ecu_locked"
        case isPhysicalLockLocked = "erl_locked"
        case batteryPercentage = "battery_percentage"
        case isCharging = "charging"
        case lastFullChargeDate = "last_full_charge"
        case range
        case odometer
    }
    
    public init(
        isPoweredOn: Bool? = nil,
        isDigitalLockLocked: Bool? = nil,
        isPhysicalLockLocked: Bool? = nil,
        batteryPercentage: Int? = nil,
        isCharging: Bool? = nil,
        lastFullChargeDate: Date? = nil,
        range: Int? = nil,
        odometer: Int? = nil) {
        
        self.isPoweredOn = isPoweredOn
        self.isDigitalLockLocked = isDigitalLockLocked
        self.isPhysicalLockLocked = isPhysicalLockLocked
        self.batteryPercentage = batteryPercentage
        self.isCharging = isCharging
        self.lastFullChargeDate = lastFullChargeDate
        self.range = range
        self.odometer = odometer
    }
}
