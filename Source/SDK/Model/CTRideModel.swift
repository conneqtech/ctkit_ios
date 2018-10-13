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
    public let creationDate:Date?
    public let startDate:Date?
    public let endDate:Date?
    
    
    //Calculated things
    public let calories:Double
    public let averageSpeed:Double
    public let distanceTraveled:Double
    public let co2:Double
    public let weatherIconURL:String
    
    public var coordinateList:[CTLatLonModel]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case bikeId = "bike_id"
        case name = "name"
        case rideType = "ride_type"
        case creationDate = "creation_date"
        case startDate = "start_date"
        case endDate = "end_date"
        
        case calories = "calories"
        case averageSpeed = "average_speed"
        case distanceTraveled = "distance_traveled"
        case co2 = "co2"
        case weatherIconURL = "weather_icon_url"
        
        
    }
    
}
