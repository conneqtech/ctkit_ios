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

    public let batteryPercentage:Int?
    public let isCharging:Bool?
    public let lastFullChargeDate:Date?

    enum CodingKeys: String, CodingKey {
        case isPoweredOn = "powered_on"
        case isDigitalLockLocked = "ecu_locked"
        case isPhysicalLockLocked = "erl_locked"
        case batteryPercentage = "battery_percentage"
        case isCharging = "charging"
        case lastFullChargeDate = "last_full_charge"
    }
}
