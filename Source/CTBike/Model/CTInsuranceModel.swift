//
//  CTInsuranceModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 05/04/2019.
//

import Foundation

public struct CTInsuranceModel: CTBaseModel {

    public let polisNumber: String?
    public let provider: String
    public let cascoCoverage :Bool

    enum CodingKeys: String, CodingKey {
        case polisNumber = "polis_number"
        case provider = "provider"
        case cascoCoverage = "casco_coverage"
    }
    public init(polisNumber: String?, provider: String, cascoCoverage: Bool) {
        self.polisNumber = polisNumber
        self.provider = provider
        self.cascoCoverage = cascoCoverage
    }
}
