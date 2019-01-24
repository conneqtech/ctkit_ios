//
//  CTAddressModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 13/11/2018.
//

import Foundation

public struct CTAddressModel: CTBaseModel {

    public let postalCode: String
    public let houseNumber: String
    public let houseNumberAddition: String
    public let countryCode: String
    public let street: String
    public let city: String
    public let province: String

    enum CodingKeys: String, CodingKey {
        case postalCode = "postcode"
        case houseNumber = "house_number"
        case houseNumberAddition = "addition"
        case countryCode = "country_code"
        case street = "street"
        case city = "city_name"
        case province = "province_name"
    }

    public init () {
        self.postalCode = ""
        self.houseNumber = ""
        self.houseNumberAddition = ""
        self.countryCode = ""
        self.street = ""
        self.city = ""
        self.province = ""
    }
}
