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
    
    public let firstName: String?
    public let lastName: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CTUserModel.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
    }
}
