//
//  CTTroubleshootingMoel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 18/06/2020.
//

import Foundation

public struct CTTroubleshootingModel: CTBaseModel {
    public var key: String
    public var status: Bool
    public var value: String
    public var valueType: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case status
        case value
        case valueType = "value_type"
    }
    
    public init(key: String, status: Bool, value: String, valueType: String) {
        self.key = key
        self.status = status
        self.value = value
        self.valueType = valueType
    }
}
