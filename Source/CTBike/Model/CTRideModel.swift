//
//  CTRideModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTRideModel: CTBaseModel {
    //Attributes
    public let id: Int
    public var userId: Int
    public var bikeId: Int
    public var name: String
    public var rideType: String
    public var creationDate: Date
    public var startDate: Date
    public var endDate: Date

    //Calculated things
    public let calories: Double
    public let averageSpeed: Double
    public let distanceTraveled: Double
    public let co2: Double
    public let weatherIconURL: String

    enum CodingKeys: String, CodingKey {
        case weatherInfo = "weather_info"
        case id = "id"
        case userId = "user_id"
        case bikeId = "bike_id"
        case name = "name"
        case rideType = "ride_type"
        case creationDate = "creation_date"
        case startDate = "start_date"
        case endDate = "end_date"

        case calories = "calories"
        case averageSpeed = "avg_speed"
        case distanceTraveled = "distance_traveled"
        case co2 = "co2"
        case weatherIconURL = "icon_url"
    }

    public init(id: Int, userId: Int, bikeId: Int, name: String, rideType: String, creationDate: Date, startDate: Date, endDate: Date, calories: Double, averageSpeed: Double, distanceTraveled: Double, co2: Double, weatherIconURL: String) {
        self.id = id
        self.userId = userId
        self.bikeId = bikeId
        self.name = name
        self.rideType = rideType
        self.creationDate = creationDate
        self.startDate = startDate
        self.endDate = endDate
        self.calories = calories
        self.averageSpeed = averageSpeed
        self.distanceTraveled = distanceTraveled
        self.co2 = co2
        self.weatherIconURL = weatherIconURL
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let weatherInfo = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weatherInfo)

        weatherIconURL = try! weatherInfo.decode(String.self, forKey: .weatherIconURL)

        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        bikeId = try container.decode(Int.self, forKey: .bikeId)
        name = try container.decode(String.self, forKey: .name)
        rideType = try container.decode(String.self, forKey: .rideType)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)

        calories = try container.decode(Double.self, forKey: .calories)
        averageSpeed = try container.decode(Double.self, forKey: .averageSpeed)
        distanceTraveled = try container.decode(Double.self, forKey: .distanceTraveled)
        co2 = try container.decode(Double.self, forKey: .co2)

    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(rideType, forKey: .rideType)
        try container.encode(startDate.toAPIDate(), forKey: .startDate)
        try container.encode(endDate.toAPIDate(), forKey: .endDate)

    }

}
