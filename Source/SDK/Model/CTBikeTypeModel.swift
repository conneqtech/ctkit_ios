//
//  CTBikeTypeModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/01/2019.
//

import Foundation

public struct CTBikeTypeModel: CTBaseModel {
    public let id: Int
    public let name: String
    public let registrationFlow: CTBikeRegistrationFlow

    public let secondFactorTranslationKey: String
    public let secondFactorLocationImage: String?

    public let images: [String]
    public let features: CTBikeFeatureModel

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case registrationFlow = "registration_flow"
        case secondFactorTranslationKey = "second_factor_location_translation_key"
        case secondFactorLocationImage = "second_factor_location_image"
        case images
        case features
    }
}
