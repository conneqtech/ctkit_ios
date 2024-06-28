//
//  User.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

/**
    CTUserModel represents any user on the platform, either the current logged in user or a user that has access to a bike.
 */
public struct CTUserModel: CTBaseModel {

    ///Identifier of the user in the database, this identifier is used in most calls to the API.
    public let id: Int

    ///Email address the user used to login. If the login was with Facebook or Google we will use the accounts email address.
    public let email: String

    //Calculated variable created from firstName and lastName
    public var displayName: String {
        get {
            if let firstName = firstName, let lastName = lastName {
                return "\(firstName) \(lastName)"
            } else if let unwrappedName = name {
                return unwrappedName
            }
            return ""
        }
    }

    ///First name of the user, maximum length 255 is characters
    public var firstName: String?

     ///Last name of the user, maximum length 255 is characters
    public var lastName: String?

    //Full name of the user
    public var name: String?

    ///Initials of the user, maximum length 255 is characters
    public var initials: String?

    ///Phone number of the user
    public var phoneNumber: String?

    ///Gender, this can be 'm' for male, 'f' for female, or 'o' for not disclosed
    public var gender: String?

    ///URL to the profileImage
    public var profileImage: String?

    ///Boolean that indicates if the user verified their email
    public var emailIsVerified: Bool?

    //Address attributes

    ///Street without house number, maximum length 255 is characters
    public var street: String?

    ///Integer representation of the housenumber, any additions should be stored in the 'freeform' `houseNumberAddition` field
    public var houseNumber: Int?

    ///Any additions to the housenumber like 'C5' or 'Apt. 1' should be added here
    public var houseNumberAddition: String?

    ///City of the user, maximum length 255 is characters
    public var city: String?

    ///Two letter representation of the country
    public var country: String?

    ///Postalcode, maximum length is 10 characters
    public var postalCode: String?
    
    public var privacyStatementAccepted: Bool?
    
    public var privacyStatementAcceptedOn: Date?
        
    public var creationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case name = "name"

        case initials = "initials"
        case phoneNumber = "phone_number"
        case gender = "gender"
        case profileImage = "avatar_url"
        case emailIsVerified = "is_email_verified"

        case street = "address"
        case houseNumber = "house_number"
        case houseNumberAddition = "house_number_addition"
        case city = "city"
        case country = "country"
        case postalCode = "postal_code"
        case privacyStatementAccepted = "privacy_statement_accepted"
        case privacyStatementAcceptedOn = "privacy_statement_accepted_on"
        case creationDate = "creation_date"
    }

    public init(withEmail email: String, andName name: String) {
        self.id = -1
        self.name = name
        self.email = email
    }

    /**
     Implementation of the encode function to only encode the fields the API allows us to patch.
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(initials, forKey: .initials)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(gender, forKey: .gender)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(name, forKey: .name)

        try container.encode(street, forKey: .street)
        try container.encode(houseNumber, forKey: .houseNumber)
        try container.encode(houseNumberAddition, forKey: .houseNumberAddition)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(privacyStatementAccepted, forKey: .privacyStatementAccepted)
    }

    public static func splitPhone(number: String) -> (countryCode: UInt64?, number: String) {
        let splitNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted)
        var phoneNumber = number
        var countryCodeValue: UInt64?

        if splitNumber.count == 2 {
            countryCodeValue = UInt64(splitNumber[0])
            phoneNumber = splitNumber[1]
        }
        if splitNumber.count == 3 {
            countryCodeValue = UInt64(splitNumber[1])
            phoneNumber = splitNumber[2]
        }
        return (countryCodeValue, phoneNumber)
    }
}
