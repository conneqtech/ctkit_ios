//
//  CTFilter.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/03/2019.
//

import Foundation

public struct CTFilter: CTBaseModel {
    public let type: String
    public let fieldName: String
    public let filterOperator: String
    public let filterValue: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case fieldName = "fieldname"
        case filterOperator = "operator"
        case filterValue = "filter_value"
    }
}
