//
//  CTPartnerModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 20/11/2018.
//

import Foundation

public struct CTTheftCasePartnerModel: CTBaseModel {
    public let id: Int
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let address: String
    public let postalCode: String
    public let city: String
    public let countryCode:String
    public let logoUrl: String
    public let descriptions: [String:String]
    
    enum CodingKeys: String,CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phoneNumber = "phone_number"
        case address = "address"
        case postalCode = "postal_code"
        case city = "city"
        case countryCode = "country"
        case logoUrl = "logo"
        case descriptions = "descriptions"
    }
}
