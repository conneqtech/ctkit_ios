//
//  CTMeta.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/03/2019.
//

import Foundation

public struct CTMeta: CTBaseModel {
    public let limit: Int
    public let offset: Int
    public let totalRecords: Int
    
    public let availableFilterFieldNames: [String]
    public let availableOrderFieldNames: [String]
    
    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case totalRecords = "total_records"
        case availableFilterFieldNames = "available_filter_fieldnames"
        case availableOrderFieldNames = "available_order_fieldnames"
    }
}
