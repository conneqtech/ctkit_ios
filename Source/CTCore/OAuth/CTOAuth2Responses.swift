//
//  CTOAuth2Responses.swift
//  CTKit
//
//  Created by Gert-Jan Vercauteren on 24/07/2018.
//  Copyright © 2018 Conneqtech. All rights reserved.
//

public struct CTCredentialResponse: Codable {
    
    public var accessToken: String
    public var refreshToken: String?
    public var expiresIn: Int
    public var scope: String?
    public var tokenType: String
    public var tokenId: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope = "scope"
        case tokenType = "token_type"
        case tokenId = "id_token"
    }
}

public struct CTOAuth2ErrorResponse: Codable, Error {
    var type: String
    var title: String
    var status: Int
    var detail: String

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case status
        case detail
    }
}
