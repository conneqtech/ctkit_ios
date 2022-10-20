//
//  CTNewSubscriptionModel.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation

public struct CTSubscriptionStatusModel: CTBaseModel {
    public let feature: String
    public let startDate: String
    public let endDate: String?
    public let cancelDate: String?
    enum CodingKeys: String, CodingKey {
        case feature
        case startDate = "start_date"
        case endDate = "end_date"
        case cancelDate = "cancel_date"
    }
}

public struct CTNewSubscriptionModel: CTBaseModel {
    public let status: CTSubscriptionStatusModel?

    enum CodingKeys: String, CodingKey {
        case status
    }
}
