//
//  CTNewSubscriptionModel.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation

public struct CTSubscriptionStatusModel: CTBaseModel {
    
    public let feature: String?
    public let startDateString: String?
    public var startDate: Date? {
        get {
            return self.startDateString?.fromAPIDate()
        }
    }
    public let endDateString: String?
//    public let endDate: Date?
    public let cancelDateString: String?
//    public let cancelDate: Date?e
    enum CodingKeys: String, CodingKey {
        case feature
        case startDateString = "startDate"
        case endDateString = "endDate"
        case cancelDateString = "cancelDate"
    }
}

public struct CTNewSubscriptionModel: CTBaseModel {
    public let status: CTSubscriptionStatusModel?
}
