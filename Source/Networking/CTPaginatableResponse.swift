//
//  CTPaginatableResponse.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 20/11/2018.
//

import Foundation

public struct CTPaginatableResponse<T>: Codable where T: Codable {
    public let filters: [CTFilterModel]
    public let orderClauses: [CTOrderClauseModel]
    public let data: [T]

    public let limit: Int
    public let offset: Int
    public let availableFilterFieldNames: [String]
    public let availableOrderFieldNames: [String]

    enum CodingKeys: String, CodingKey {
        case filters = "filters"
        case orderClauses = "order_clauses"
        case data = "data"
        case meta = "meta"
        case limit = "limit"
        case offset = "offset"
        case availableFilterFieldNames = "available_filter_fieldnames"
        case availableOrderFieldNames = "available_order_fieldnames"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let meta = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .meta)
        filters = try! container.decode([CTFilterModel].self, forKey: .filters)
        orderClauses = try! container.decode([CTOrderClauseModel].self, forKey: .orderClauses)
        data = try! container.decode([T].self, forKey: .data)

        limit = try! meta.decode(Int.self, forKey: .limit)
        offset = try! meta.decode(Int.self, forKey: .offset)
        availableFilterFieldNames = try! meta.decode([String].self, forKey: .availableFilterFieldNames)
        availableOrderFieldNames = try! meta.decode([String].self, forKey: .availableOrderFieldNames)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var meta = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .meta)

        try container.encode(filters, forKey: .filters)
        try container.encode(orderClauses, forKey: .orderClauses)
        try container.encode(data, forKey: .data)
        try meta.encode(limit, forKey: .limit)
        try meta.encode(offset, forKey: .offset)
        try meta.encode(availableFilterFieldNames, forKey: .availableFilterFieldNames)
        try meta.encode(availableOrderFieldNames, forKey: .availableOrderFieldNames)
    }

}
