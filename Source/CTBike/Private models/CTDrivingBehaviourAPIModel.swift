//
//  CTDrivingBehaviourAPIModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation

public enum CTDayPart: String, Codable {
    case morning
    case afternoon
    case evening
    case night
}

struct CTDrivingBehaviourAPIModel: CTBaseModel {

    var caloriesBurned: Int
    var averageSpeed: Int
    var carbonDioxide: Int
    var numRides: Int
    var grouping: CTDayPart
    var distance: Int

    enum CodingKeys: String, CodingKey {
        case caloriesBurned = "calories"
        case averageSpeed = "speed"
        case carbonDioxide = "carbon_dioxide"
        case numRides = "num_rides"
        case grouping = "grouping"
        case distance = "distance"
    }
}
