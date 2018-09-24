//
//  CTOAuth2Responses.swift
//  CTKit
//
//  Created by Gert-Jan Vercauteren on 24/07/2018.
//  Copyright © 2018 Conneqtech. All rights reserved.
//

public struct CTOAuth2TokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
    var expiresIn: Int
    var scope: String?
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope = "scope"
        case tokenType = "token_type"
    }
}

public struct CTOAuth2ErrorResponse: Codable, Error {
    var type: String
    var title: String
    var status: Int
    var detail: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case title = "title"
        case status = "status"
        case detail = "detail"
    }
}
