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

    public let userId: Int
    public let displayName: String
    public let avatarUrl: String

    public let requestDate: Date
    public let administerDate: Date?
    public let revokedDate: Date?

     enum CodingKeys: String, CodingKey {
        case id
        case inviteStatus = "invite_status"
        case userId = "user_id"
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case requestDate = "requested_on"
        case administerDate = "administered_on"
        case revokedDate = "revoked_on"
    }
}
