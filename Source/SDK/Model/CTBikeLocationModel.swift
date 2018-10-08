//
//  CTBikeHistoryItemModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/10/2018.
//

import Foundation

public class CTBikeLocationModel: CTBaseModel {
    
    public let longitude: Double
    public let latitude: Double
    public let date: String
    public let speed: Int
    public let batteryPercentage: Int
    public let isMoving: Bool
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case date = "date"
        case speed = "speed"
        case batteryPercentage = "battery_percentage"
        case isMoving = "is_moving"
    }
}
