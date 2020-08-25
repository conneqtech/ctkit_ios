//
//  CTDealerModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 20/09/2019.
//

import Foundation

public struct CTDealerModel: CTBaseModel {
    public let id: Int
    public let name: String
    public let reference: String

    public let address: String?
    public let postalCode: String?
    public let city: String?
    public let country: String?

    public let email: String?
    public let phoneNumber: String?
    public let website: String?

    public let location: CTLatLonModel?
    public let isFixed: Bool
    
    public init(
        id: Int = 0,
        name: String = "",
        reference: String = "",
        address: String? = nil,
        postalCode: String? = nil,
        city: String? = nil,
        country: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil,
        website: String? = nil,
        location: CTLatLonModel? = nil,
        isFixed: Bool) {
        
        self.id = id
        self.name = name
        self.reference = reference
        self.address = address
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.email = email
        self.phoneNumber = phoneNumber
        self.website = website
        self.location = location
        self.isFixed = isFixed
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case reference
        case address
        case postalCode = "postal_code"
        case city
        case country
        case email
        case phoneNumber = "phone_number"
        case website
        case location
        case isFixed = "is_fixed"
    }
}
