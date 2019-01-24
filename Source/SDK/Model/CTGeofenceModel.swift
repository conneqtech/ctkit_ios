//
//  CTGeofenceModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation
import MapKit

public struct CTGeofenceModel: CTBaseModel {

    public let id:Int
    public var name:String
    public var radius:Double
    public var center:CTLatLonModel
    public var bikeId:Int

    public init(withBikeId bikeId: Int, name: String, radius: Double, center: CTLatLonModel) {
        self.id = -1
        self.bikeId = bikeId
        self.name = name
        self.radius = radius
        self.center = center
    }
    
    public init(withIdentifier identifier: Int, andBikeId bikeId: Int, name: String, radius: Double, center: CTLatLonModel) {
        self.id = identifier
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(center, forKey: .center)
        try container.encode(radius, forKey: .radius)
    }
    
    public func asCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.center.latitude, self.center.longitude)
    }
}
