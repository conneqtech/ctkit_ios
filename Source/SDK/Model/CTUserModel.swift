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
    public let displayName: String {
        get {
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            
            return ""
        }
    }
    
    public var firstName: String?
    public var lastName: String?
    
    public var initials:String?
    public var gender:String?
    public var avatar:String?
    public let emailIsVerified:Bool?
    
    //Address attributes
    public var address:String?
    public var houseNumber:Int?
    public var houseNumberAddition:String?
    public var city:String?
    public var country:String?
    public var postalCode:String?

    //Location

    public let updatedLocation:CTLatLonModel?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        
        case initials = "initials"
        case gender = "gender"
        case avatar = "avatar_url"
        case emailIsVerified = "is_email_verified"
        
        case address = "address"
        case houseNumber = "house_number"
        case houseNumberAddition = "house_number_addition"
        case city = "city"
        case country = "country"
        case postalCode = "postal_code"
        
        case updatedLocation = "updated_location"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(initials, forKey: .initials)
        try container.encode(gender, forKey: .gender)
        try container.encode(avatar, forKey: .avatar)
        
        try container.encode(address, forKey: .address)
        try container.encode(houseNumber, forKey: .houseNumber)
        try container.encode(houseNumberAddition, forKey: .houseNumberAddition)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(postalCode, forKey: .postalCode)
    }
}
