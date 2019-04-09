//
//  CTSubscriptionProduct.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/03/2019.
//

import Foundation

public enum CTSubscriptionProductType: Int, Codable {
    case connectivity = 1
    case insurance = 2
}

public enum CTInsuranceType: String, Codable {
    case casco = "EBD_OC"
    case theft = "EBD_OD"
}

public struct CTSubscriptionProductModel: CTBaseModel {

    public let id: Int

    public let title: String
    public let subtitle: String
    public let description: String

    public let logoUrl: String

    public let price: Double
    public let activationFee: Double
    public let currency: String

    public let minDurationInMonths: Int
    public let paymentIntervalInMonths: Int

    public let childProductId: Int?
    public let productType: CTSubscriptionProductType

    enum CodingKeys: String, CodingKey {
        case id

        case title
        case subtitle
        case description

        case logoUrl = "logo_url"

        case price
        case activationFee = "activation_fee"
        case currency

        case minDurationInMonths = "min_duration"
        case paymentIntervalInMonths = "interval"

        case childProductId = "child_product"
        case productType = "type"
    }
}
