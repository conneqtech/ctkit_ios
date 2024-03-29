//
//  CTProductModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation

public struct CTProductModel: CTBaseModel {
    public let id: Int
    public let title: String?
    public let subtitle: String?
    public let description: String?
    public let logoUrl: String?
    public let price: Double
    public let activationFee: Double
    public let currency: String?
    public let type: Int
    public let providerId: Int
    public let insuranceType: CTInsuranceType?
    private let childProduct: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case description
        case logoUrl = "logo_url"
        case price
        case activationFee = "activation_fee"
        case currency
        case type
        case providerId = "provider_id"
        case childProduct = "child_product"
        case insuranceType = "insurance_id"
    }

    public init(withTitle title: String, description: String, type: Int, providerId: Int) {
        self.id = -1
        self.providerId = providerId
        self.title = title
        self.subtitle = ""
        self.description = description
        self.logoUrl = ""
        self.currency = ""
        self.price = -1
        self.activationFee = -1
        self.type = type
        self.childProduct = -1
        self.insuranceType = nil
    }

}
