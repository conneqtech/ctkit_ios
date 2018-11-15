//
//  CTRideModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTRideModel: CTBaseModel {
    
    //Attributes
    public let id:Int
    public let userId:Int
    public let bikeId:Int
    public let name:String
    public let rideType:String
    public let creationDate:String
    public let startDate:String
    public let endDate:String
    
    
    //Calculated things
    public let calories:Double
    public let averageSpeed:Double
    public let distanceTraveled:Double
    public let co2:Double
    public let weatherIconURL:String
    
    public var coordinateList:[CTLatLonModel]?
    
    
    enum CodingKeys: String, CodingKey {
//        case params = "params"
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
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        var params = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .params)
//        
//        try container.encode(weatherIconURL, forKey: .weatherIconURL)
//    
//    }
    
}
