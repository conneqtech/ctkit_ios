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

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
        case date = "date"
        case speed = "speed"
    }

    public init(withLongitude longitude: Double = 0, latitude: Double = 0, date: Date = Date(), speed: Int = 0) {
        self.longitude = longitude
        self.latitude = latitude
        self.date = date
        self.speed = speed
    }

    public func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }

    public func asLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
