//
//  CTSubscriptionModel.swift
//  Alamofire
//
//  Created by De backer Klaartje on 29/01/2020.
//

import Foundation

public struct CTSubscriptionModel: CTBaseModel {
    
    public let startDate: Date?
    public let endDate: Date?
    public let cancelled: Bool?
    public let type: CTSubscriptionProductType
    public let logoUrl: String
    public let insurance: CTInsuranceModel?
    public let active: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case startDate = "start_date"
        case endDate = "end_date"
        case cancelled
        case type = "product_type_id"
        case logoUrl = "logo_url"
        case insurance
        case active
    }
    
    // Note: we need this init for testing purposes
    public init(
        startDate: Date? = nil,
        endDate: Date? = nil,
        cancelled: Bool? = nil,
        productTypeId: CTSubscriptionProductType = .insurance,
        logoUrl: String = "",
        insurance: CTInsuranceModel? = nil,
        active: Bool = true
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.cancelled = cancelled
        self.type = productTypeId
        self.logoUrl = logoUrl
        self.insurance = insurance
        self.active = active
    }
}

public enum CTSubscriptionProductType: Int, Codable {
    case connectivity = 1
    case insurance = 2
}
