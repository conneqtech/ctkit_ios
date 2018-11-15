//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public struct CTBikeModel: CTBaseModel {
    public let id: Int? = nil
    public let imei: String
    public let frameIdentifier: String
    public let batteryPercentage:Int = 0
    public let lastLocation: CTBikeLocationModel? = nil
    public let owner: CTUserModel? = nil
    public let linkedUsers: [CTUserModel]? = nil
    
    public var name: String
    public var keyIdentifier: String?
    public var themeColor: String?
    public var imageUrl:String?
    public var creationDate:String?
    
    public init(name: String, imei: String, frameIdentifier: String) {
        self.imei = imei
        self.frameIdentifier = frameIdentifier
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imei = "imei"
        case name = "name"
        case frameIdentifier = "frame_number"
        case keyIdentifier = "key_number"
        case batteryPercentage = "battery_percentage"
        case lastLocation = "last_location"
        case owner = "owning_user"
        case linkedUsers = "linked_users"
        case themeColor = "color_hex"
        case imageUrl = "bike_image_url"
        case creationDate = "creation_date"
    }
}
