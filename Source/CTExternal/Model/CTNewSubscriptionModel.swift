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
}

public struct CTNewSubscriptionModel: CTBaseModel {
    public let status: CTSubscriptionStatusModel?
}
