//
//  CTLinkedUserModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//

import Foundation

public enum CTInviteStatus: String, Codable {
    case open
    case denied
    case accepted
    case revoked
}

public struct CTInviteModel: CTBaseModel {

    public let id: String
    public let status: CTInviteStatus

    public let linkedUserId: Int
    public let displayName: String
    public let avatarUrl: String

    public let statusChangeDate: Date?
    public let isEmergencyContact: Bool

     enum CodingKeys: String, CodingKey {
        case id
        case status = "invite_status"
        
        case linkedUserId = "user_id"
        case displayName = "display_name"
        case avatarUrl = "avatar_url"

        case statusChangeDate = "status_changed_on"
        
        case isEmergencyContact = "is_emergency_contact"
    }
}
