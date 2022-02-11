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
    
    public init(en: String, de: String, nl: String) {
        self.en = en
        self.de = de
        self.nl = nl
    }
}

public struct CTTheftCasePartnerModel: CTBaseModel {
    public let id: Int
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let address: String
    public let postalCode: String
    public let city: String
    public let country: String
    public let logo: String
    public let description: CTTheftCasePartnerDescriptionModel
    public let filesTheftReport: Bool?
    

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
    
    public init(id: Int, name: String, email: String, phoneNumber: String, address: String, postalCode: String, city: String, country: String, logo: String, description: CTTheftCasePartnerDescriptionModel, filesTheftReport: Bool? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.logo = logo
        self.description = description
        self.filesTheftReport = filesTheftReport
    }
}
