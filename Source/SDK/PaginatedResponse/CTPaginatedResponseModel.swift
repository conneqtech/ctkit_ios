//
//  CTPaginatedResponseModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/03/2019.
//

import Foundation

public struct CTPaginatedResponseModel<T>: CTBaseModel where T: CTBaseModel {
    public let filters: [CTFilter]
    public let orderClauses: [CTOrderClause]
    public let meta: CTMeta

    public let data: [T]

    enum CodingKeys: String, CodingKey {
        case filters
        case orderClauses = "order_clauses"
        case meta
        case data
    }
}
