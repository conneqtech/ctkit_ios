//
//  CTInsuranceModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 05/04/2019.
//

import Foundation

public struct CTInsuranceModel: CTBaseModel {

    public let id: Int
    public let transactionId: String?
    public let polisNumber: String?
    public let polisPK: String?
    public let provider: String
    public let cascoCoverage :Bool

    enum CodingKeys: String, CodingKey {
        case id
        case transactionId = "transaction_id"
        case polisNumber = "polis_number"
        case polisPK = "polis_pk"
        case provider = "provider"
        case cascoCoverage = "casco_coverage"
    }
    
    public init(id: Int, transactionId: String?, polisNumber: String?, polisPK: String?, provider: String, cascoCoverage: Bool) {
        self.id = id
        self.transactionId = transactionId
        self.polisNumber = polisNumber
        self.polisPK = polisPK
        self.provider = provider
        self.cascoCoverage = cascoCoverage
    }
}
