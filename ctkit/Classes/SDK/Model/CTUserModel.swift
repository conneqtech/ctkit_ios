//
//  User.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public class CTUserModel: CTBaseModel {
    
    public let id: Int
    
    public let email: String
    public var displayName: String {
        get {
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            
            return ""
        }
    }
    
    public var firstName: String?
    public var lastName: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}
