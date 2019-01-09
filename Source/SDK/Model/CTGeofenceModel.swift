//
//  CTGeofenceModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation

public struct CTGeofenceModel: CTBaseModel {

    public let id:Int
    public let name:String
    public let radius:Double
    public let center:CTLatLonModel
    public let bikeId:Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case radius = "radius"
        case center = "center"
        case bikeId = "bike_id"
    }
}
