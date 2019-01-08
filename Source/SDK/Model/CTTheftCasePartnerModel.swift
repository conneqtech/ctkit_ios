//
//  CTTheftCasePartner.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//

import Foundation

public struct CTTheftCasePartnerDescriptionModel: CTBaseModel {
    public let en: String
    public let de: String
    public let nl: String
}

public struct CTTheftCasePartnerModel: CTBaseModel {
    
    public let id: Int?
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let address: String
    public let postalCode: String
    public let city: String
    public let country: String
    public let logo: String
    public let description: CTTheftCasePartnerDescriptionModel

    
     enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phoneNumber = "phone_number"
        case address = "address"
        case postalCode = "postal_code"
        case city = "city"
        case country = "country"
        case logo = "logo"
        case description = "descriptions"
    }
}
