//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public struct CTBikeModel: CTBaseModel {
    public let id: Int?
    public let imei: String
    public let frameIdentifier: String
    public var batteryPercentage:Int?
    public var lastLocation: CTBikeLocationModel?
    public var owner: CTBasicUserModel?
    public var linkedUsers: [CTBasicUserModel]?

    public var name: String
    public var keyIdentifier: String?
    public var themeColor: String?
    public var imageUrl:String?
    public var creationDate:String?
    public var isStolen:Bool?
    public var isRequestingUserOwner: Bool?
    
    public init(withImei imei: String, frameIdentifier identifier: String, name: String) {
        self.id = -1
        self.imei = imei
        self.frameIdentifier = identifier
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
        case isStolen = "is_stolen"
        case isRequestingUserOwner = "is_requesting_user_owner"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(keyIdentifier, forKey: .keyIdentifier)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(frameIdentifier, forKey: .frameIdentifier)
        try container.encode(isStolen, forKey: .isStolen)

    }

}
