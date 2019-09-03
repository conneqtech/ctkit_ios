//
//  CTBikeFeatureModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//

import Foundation

public struct CTBikeFeatureModel: CTBaseModel {
    public let bluetooth: Bool
    public let physicalLock: Bool
    public let digitalLock: Bool
    public let powerToggle: Bool
    public let lightToggle: Bool

    public let chargeIndication: Bool
    public let lastFullChargeDate: Bool
    public let range: Bool

    enum CodingKeys: String, CodingKey {
        case bluetooth
        case physicalLock = "erl_lock"
        case digitalLock = "ecu_lock"
        case powerToggle = "power_toggle"
        case lightToggle = "light_toggle"

        case chargeIndication = "charge_indication"
        case lastFullChargeDate = "last_full_charge_date"
        case range
    }
}
