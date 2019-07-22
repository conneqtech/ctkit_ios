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

    enum CodingKeys: String, CodingKey {
        case id
        case transactionId = "transaction_id"
        case polisNumber = "polis_number"
        case polisPK = "polis_pk"
    }
}
