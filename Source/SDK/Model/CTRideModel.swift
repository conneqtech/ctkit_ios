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
    
/*    Thinking.... */
//    public var coordinateList:CTLatLonModel?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case bikeId = "bikeId"
        case name = "name"
        case rideType = "rideType"
        case creationDate = "creationDate"
        case startDate = "startDate"
        case endDate = "endDate"
        
        case calories = "calories"
        case averageSpeed = "averageSpeed"
        case distanceTraveled = "distanceTraveled"
        case co2 = "co2"
        case weatherIconURL = "weatherIconURL"
    }
    
}
