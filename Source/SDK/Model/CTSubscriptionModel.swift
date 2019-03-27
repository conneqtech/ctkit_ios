//
//  CTSubscriptionModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation

public struct CTSubscriptionModel: CTBaseModel {
    public let id: Int
    public let userId: Int
    public let bikeId: Int
    public let isCancelled: Bool
    public let startDate: Date
    public let endDate: Date?
    public let productId: Int
    public let type: CTSubscriptionProductType

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case bikeId = "bike_id"
        case isCancelled = "cancelled"
        case startDate = "start_date"
        case endDate = "end_date"
        case productId = "product_id"
        case type = "type"
        case product = "product"
    }

    public init(withUserId userId: Int, bikeId: Int, productId: Int, type: CTSubscriptionProductType) {
        self.id = -1
        self.userId = userId
        self.bikeId = bikeId
        self.productId = productId
        self.isCancelled = false
        self.startDate = Date()
        self.endDate = Date()
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        bikeId = try container.decode(Int.self, forKey: .bikeId)
        isCancelled = try container.decode(Bool.self, forKey: .isCancelled)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try? container.decode(Date.self, forKey: .endDate)
        productId = try container.decode(Int.self, forKey: .productId)

        let product  = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .product)
        type = try product.decode(CTSubscriptionProductType.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
        // Nothing to encode, we will never create subscriptions from CTKit.
    }
}
