//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public struct CTBikeModel: CTBaseModel {
    public let id: Int
    public let imei: String
    public let frameIdentifier: String
    public var lastLocation: CTBikeLocationModel?
    public var owner: CTBasicUserModel?
    
    public var name: String
    public var keyIdentifier: String?
    public var themeColor: String?
    public var imageUrl: String?
    public var creationDate: Date?
    public var isStolen: Bool?
    public var isRequestingUserOwner: Bool
    public var type: String?
    
    public let bluetoothPassword: String?
    public var bluetoothName: String?
    
    public let inviteUri: String?
    public let articleNumber: String?
    
    public let dealerId: Int?
    
    public let activationCode: String?
    
    public var isRideInProgress: Bool?
    
    public init(id: Int = 0,
                imei: String = "860000000000000",
                frameIdentifier: String = "FR4M3NUMB3R",
                lastLocation: CTBikeLocationModel? = nil,
                owner: CTBasicUserModel? = nil,
                name: String = "Lightning mc queso",
                keyIdentifier: String? = nil,
                themeColor: String? = nil,
                imageUrl: String? = nil,
                creationDate: Date? = nil,
                isStolen: Bool? = false,
                isRequestingUserOwner: Bool = false,
                type: String? = nil,
                bluetoothPassword: String? = nil,
                bluetoothName: String? = nil,
                inviteUri: String? = nil,
                articleNumber: String? = nil,
                dealerId: Int? = nil,
                activationCode: String? = nil) {
        self.id = id
        self.imei = imei
        self.frameIdentifier = frameIdentifier
        self.lastLocation = lastLocation
        self.owner = owner
        self.name = name
        self.keyIdentifier = keyIdentifier
        self.themeColor = themeColor
        self.imageUrl = imageUrl
        self.creationDate = creationDate
        self.isStolen = isStolen
        self.isRequestingUserOwner = isRequestingUserOwner
        self.type = type
        self.bluetoothPassword = bluetoothPassword
        self.bluetoothName = bluetoothName
        self.inviteUri = inviteUri
        self.articleNumber = articleNumber
        self.dealerId = dealerId
        self.activationCode = activationCode
    }
    
    public init(withId id: Int,
                imei: String,
                frameIdentifier identifier: String,
                name: String,
                isOwner: Bool = true,
                articleNumber: String? = nil
    ) {
        self.id = id
        self.imei = imei
        self.frameIdentifier = identifier
        self.name = name
        self.isRequestingUserOwner = isOwner
        self.bluetoothPassword = ""
        self.bluetoothName = ""
        self.inviteUri = ""
        self.articleNumber = articleNumber
        self.dealerId = nil
        self.activationCode = ""
    }
    
    public init(withImei imei: String, frameIdentifier identifier: String, name: String, isOwner: Bool = true) {
        self.id = -1
        self.imei = imei
        self.frameIdentifier = identifier
        self.name = name
        self.isRequestingUserOwner = isOwner
        self.bluetoothPassword = ""
        self.bluetoothName = ""
        self.inviteUri = ""
        self.articleNumber = ""
        self.dealerId = nil
        self.activationCode = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imei = "imei"
        case name = "name"
        case frameIdentifier = "frame_number"
        case keyIdentifier = "key_number"
        case lastLocation = "last_location"
        case owner = "owning_user"
        case themeColor = "color_hex"
        case imageUrl = "bike_image_url"
        case creationDate = "creation_date"
        case isStolen = "is_stolen"
        case isRequestingUserOwner = "is_requesting_user_owner"
        case type = "type"
        
        case bluetoothPassword = "blepass"
        case bluetoothName = "blename"
        
        case inviteUri = "invite_code_uri"
        case articleNumber = "article_number"
        
        case dealerId = "dealer_id"
        case activationCode = "activation_code"
        
        case isRideInProgress = "ride_in_progress"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(keyIdentifier, forKey: .keyIdentifier)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(frameIdentifier, forKey: .frameIdentifier)
        try container.encode(bluetoothName, forKey: .bluetoothName)
        try container.encode(isStolen, forKey: .isStolen)
        try container.encode(isRideInProgress, forKey: .isRideInProgress)
    }
}
