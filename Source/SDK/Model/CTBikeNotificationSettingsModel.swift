//
//  File.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/03/2019.
//

import Foundation

public struct CTBikeNotificationSettingsModel: CTBaseModel {

    public let bikeId: Int

    public var batteryNotify: Bool
    public var speedNotify: Bool
    public var movingNotify: Bool
    public var motionNotify: Bool

    public init (withBikeId identifier: Int, batteryOn: Bool, speedOn: Bool, movingOn: Bool, motionOn: Bool) {
        self.bikeId = identifier
        self.batteryNotify = batteryOn
        self.speedNotify = speedOn
        self.movingNotify = movingOn
        self.motionNotify = motionOn
    }

    enum CodingKeys: String, CodingKey {
        case bikeId = "id"
        case batteryNotify = "lowbattery"
        case speedNotify = "highspeed"
        case movingNotify = "moving"
        case motionNotify = "motion"
    }
}
