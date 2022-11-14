//
//  CTTheftCasePartner.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//

import Foundation


public struct CTTheftCasePartnerModel: CTBaseModel {
    public let id: Int?
    public let name: String?
    public let email: String?
    public let phoneNumber: String?
    public let address: String?
    public let postalCode: String?
    public let city: String?
    public let country: String?
    public let logo: String?
    public var filesTheftReport: Bool?
    public var hasRecovery: Bool?
    
    

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
        case filesTheftReport = "files_theft_report"
        case hasRecovery = "has_recovery"
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
        filesTheftReport: Bool? = nil) {

        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.logo = logo
        self.filesTheftReport = filesTheftReport
    }
    
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int?.self, forKey: .id)
        name = try container.decode(String?.self, forKey: .name)
        email = try container.decode(String?.self, forKey: .email)
        
        phoneNumber = try container.decode(String?.self, forKey: .phoneNumber)
        address = try container.decode(String?.self, forKey: .address)
        postalCode = try container.decode(String?.self, forKey: .postalCode)
        city = try container.decode(String?.self, forKey: .city)
        country = try container.decode(String?.self, forKey: .country)
        logo = try container.decode(String?.self, forKey: .logo)
        filesTheftReport = try container.decode(Bool?.self, forKey: .filesTheftReport)
        hasRecovery = try container.decode(Bool?.self, forKey: .hasRecovery)
    
    }
}
