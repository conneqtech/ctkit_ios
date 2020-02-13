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
