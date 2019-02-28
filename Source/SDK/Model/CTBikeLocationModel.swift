//
//  CTBikeHistoryItemModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/10/2018.
//

import Foundation
import MapKit

public struct CTBikeLocationModel: CTBaseModel {

    public let longitude: Double
    public let latitude: Double
    public let date: Date
    public let speed: Int
    public let batteryPercentage: Double
    public let isMoving: Bool

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case date = "date"
        case speed = "speed"
        case batteryPercentage = "battery_percentage"
        case isMoving = "is_moving"
    }

    public init(withLongitude longitude: Double, latitude: Double, date: Date) {
        self.longitude = longitude
        self.latitude = latitude
        self.date = date
        self.speed = 0
        self.batteryPercentage = 0
        self.isMoving = false
    }
    
    public func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
    
    public func asLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
