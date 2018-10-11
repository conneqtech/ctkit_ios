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
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            
            return ""
        }
    }
    
    public var firstName: String?
    public var lastName: String?
    
    public let initials:String
    public let gender:String
    public let avatar:String
    public let emailIsVerified:Bool
    
    //Address attributes
    public let address:String
    public let houseNumber:String
    public let city:String
    public let country:String
    public let postalCode:String

    //Location
    public let lat:Double
    public let lon:Double
    
    public let updatedLocation:Date?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        
        case initials = "initials"
        case gender = "gender"
        case avatar = "avatar_url"
        case emailIsVerified = "email_is_verified"
        
        case address = "address"
        case houseNumber = "house_number"
        case city = "city"
        case country = "country"
        case postalCode = "postal_code"
        
        case lat = "lat"
        case lon = "lon"
        case updatedLocation = "updated_location"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}
