//
//  CTNewSubscriptionModel.swift
//
//
//  Created by Inigo Llamosas on 07/08/2024.
//

import Foundation


public class CTNewSubscriptionModel: CTBaseModel {
    
    public static func == (lhs: CTNewSubscriptionModel, rhs: CTNewSubscriptionModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String?
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
    public let next: CTNewSubscriptionModel?
    public var bike: CTBikeModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case feature
        case startDateString = "startDate"
        case endDateString = "endDate"
        case cancelDateString = "cancelDate"
        case next
    }

    // Note: we need this init for testing purposes
    public init(id: String? = nil,
                feature: String? = nil,
                startDateString: String? = nil,
                endDateString: String? = nil,
                cancelDateString: String? = nil,
                next: CTNewSubscriptionModel? = nil) {
        self.id = id
        self.feature = feature
        self.startDateString = startDateString
        self.endDateString = endDateString
        self.cancelDateString = cancelDateString
        self.next = next
    }
}
