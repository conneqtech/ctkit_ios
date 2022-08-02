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
    public let da: String
    public let sv: String
    public let fi: String
    public let fr: String
    public let es: String
    public let it: String
    public let cs: String
    public let pt: String
    public let pl: String
    public let hr: String
    
    public init(en: String, de: String, nl: String, da: String, sv: String, fi: String, fr: String, es: String, it: String, cs: String, pt: String, pl: String, hr: String) {
        self.en = en
        self.de = de
        self.nl = nl
        self.da = da
        self.sv = sv
        self.fi = fi
        self.fr = fr
        self.es = es
        self.it = it
        self.cs = cs
        self.pt = pt
        self.pl = pl
        self.hr = hr
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
    public var filesTheftReport: Bool?
    public var partnerActionDescription: String?
    

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
        case filesTheftReport = "files_theft_report"
        case partnerActionDescription = "partner_action_description"
    }
    
    public init(
        id: Int = 0,
        name: String = "",
        email: String = "",
        phoneNumber: String = "",
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "",
        logo: String = "",
        description: CTTheftCasePartnerDescriptionModel,
        filesTheftReport: Bool? = nil,
        partnerActionDescription: String? = nil) {

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
        self.partnerActionDescription = partnerActionDescription
    }
}
