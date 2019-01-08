//
//  CTBasicUserModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/01/2019.
//

import Foundation

public struct CTBasicUserModel: CTBaseModel {
    
    public let id: Int
    public let email: String?
    
    public let displayName:String
    public let profileImage: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case displayName = "display_name"
        case profileImage = "avatar_url"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(email, forKey: .email)
    }
    
}
