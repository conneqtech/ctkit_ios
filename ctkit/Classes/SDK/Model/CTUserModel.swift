//
//  User.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public struct CTUserModel: CTBaseModel {
    
    public let id: Int
    public let email: String
    public var displayName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    public let firstName: String
    public let lastName: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
