//
//  CTLinkedUserModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//

import Foundation
import RxSwift

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
    
    public init(id: String, status: CTInviteStatus, linkedUserId: Int, displayName: String, avatarUrl: String, statusChangeDate: Date?, isEmergencyContact: Bool) {
        self.id = id
        self.status = status
        self.linkedUserId = linkedUserId
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.statusChangeDate = statusChangeDate
        self.isEmergencyContact = isEmergencyContact
    }
    
    static func mockInvite() -> Observable<CTInviteModel> {
        let mockInviteModel = CTInviteModel(id: "", status: .accepted, linkedUserId: 0, displayName: "", avatarUrl: "", statusChangeDate: nil, isEmergencyContact: false)
        return Observable.of(mockInviteModel)
    }
    
    static func mockPaginatedInvite() -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        let mockCTMeta = CTMeta(limit: 0, offset: 0, totalRecords: 0, availableFilterFieldnames: [], availableOrderFieldnames: [])
        let mockPaginatedResponseModel: CTPaginatedResponseModel<CTInviteModel> = CTPaginatedResponseModel(filters: [], orderClauses: [], meta: mockCTMeta, data: [])
        return Observable.of(mockPaginatedResponseModel)
    }
}
