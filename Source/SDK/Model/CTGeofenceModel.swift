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

    public init(withBikeId bikeId: Int, name: String, radius: Double, center: CTLatLonModel) {
        self.id = -1
        self.bikeId = bikeId
        self.name = name
        self.radius = radius
        self.center = center
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case radius = "radius"
        case center = "center"
        case bikeId = "bike_id"
    }
}
