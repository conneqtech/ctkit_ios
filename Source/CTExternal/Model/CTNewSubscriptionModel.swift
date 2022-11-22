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
    public var endDate: Date? {
        get {
            return self.endDateString?.fromAPIDate()
        }
    }
    public let cancelDateString: String?
    public var cancelDate: Date? {
        get {
            return self.cancelDateString?.fromAPIDate()
        }
    }
    enum CodingKeys: String, CodingKey {
        case feature
        case startDateString = "startDate"
        case endDateString = "endDate"
        case cancelDateString = "cancelDate"
    }

    // Note: we need this init for testing purposes
    public init(feature: String? = nil,
                startDateString: String? = nil,
                endDateString: String? = nil,
                cancelDateString: String? = nil) {
        self.startDateString = startDateString
        self.endDateString = endDateString
        self.cancelDateString = cancelDateString
        self.feature = nil
    }
}

public struct CTNewSubscriptionModel: CTBaseModel {
    public let status: CTSubscriptionStatusModel?
    
    // Note: we need this init for testing purposes
    public init(status: CTSubscriptionStatusModel? = nil) {
        self.status = status
    }
}
