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
    public let name: String
    public let frameIdentifier: String
    public let keyIdentifier: String?
    public let lastLocation: CTBikeLocationModel?
    public let owner: CTUserModel
    public let linkedUsers: [CTUserModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imei = "imei"
        case name = "name"
        case frameIdentifier = "frame_number"
        case keyIdentifier = "key_number"
        case lastLocation = "last_location"
        case owner = "owning_user"
        case linkedUsers = "linked_users"
    }
}
