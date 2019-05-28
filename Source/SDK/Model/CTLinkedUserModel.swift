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

public struct CTLinkedUserModel: CTBaseModel {

    public let id: Int
    public let inviteStatus: CTInviteStatus

    public let linkedUserId: Int
    public let displayName: String
    public let avatarUrl: String

    public let statusChangeDate: Date?

     enum CodingKeys: String, CodingKey {
        case id
        case inviteStatus = "invite_status"
        
        case linkedUserId = "user_id"
        case displayName = "display_name"
        case avatarUrl = "avatar_url"

        case statusChangeDate = "status_changed_on"
    }
}
