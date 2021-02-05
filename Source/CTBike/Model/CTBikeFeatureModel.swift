//
//  CTBikeFeatureModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//

import Foundation

public struct CTBikeFeatureModel: CTBaseModel {
    public let bluetooth            : Bool
    public let physicalLock         : Bool
    public let digitalLock          : Bool
    public let powerToggle          : Bool
    public let lightToggle          : Bool

    public let chargeIndication     : Bool
    public let lastFullChargeDate   : Bool
    public let range                : Bool
    public let crashDetection       : Bool
    public let powerDistribution    : Bool
    public let shiftAdvice          : Bool
    public let odometer             : Bool
    public let nonConnected         : Bool
    public let uninsurable          : Bool
    
    public init(bluetooth: Bool = false,
                physicalLock: Bool = false,
                digitalLock: Bool = false,
                powerToggle: Bool = false,
                lightToggle: Bool = false,
                chargeIndication: Bool = false,
                lastFullChargeDate: Bool = false,
                range: Bool = false,
                crashDetection: Bool = false,
                powerDistribution: Bool = false,
                shiftAdvice: Bool = false,
                odometer: Bool = false,
                nonConnected: Bool = false, uninsurable: Bool = false) {
        self.bluetooth          = bluetooth
        self.physicalLock       = physicalLock
        self.digitalLock        = digitalLock
        self.powerToggle        = powerToggle
        self.lightToggle        = lightToggle
        self.chargeIndication   = chargeIndication
        self.lastFullChargeDate = lastFullChargeDate
        self.range              = range
        self.crashDetection     = crashDetection
        self.powerDistribution  = powerDistribution
        self.shiftAdvice        = shiftAdvice
        self.odometer           = odometer
        self.nonConnected       = nonConnected
        self.uninsurable        = uninsurable
    }

    enum CodingKeys: String, CodingKey {
        case bluetooth
        case physicalLock       = "erl_lock"
        case digitalLock        = "ecu_lock"
        case powerToggle        = "power_toggle"
        case lightToggle        = "light_toggle"

        case chargeIndication   = "charge_indication"
        case lastFullChargeDate = "last_full_charge_date"
        case range
        case crashDetection     = "crash_detection"
        case powerDistribution  = "power_distribution"
        case shiftAdvice        = "shift_advice"
        case odometer
        case nonConnected       = "non_connected"
        case uninsurable        = "uninsurable"
    }
}

