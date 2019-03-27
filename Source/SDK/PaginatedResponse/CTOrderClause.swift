//
//  CTOrderClause.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/03/2019.
//

import Foundation

public struct CTOrderClause: CTBaseModel {
    public let fieldName: String
    public let order: String

    enum CodingKeys: String, CodingKey {
        case fieldName = "fieldname"
        case order
    }
}
