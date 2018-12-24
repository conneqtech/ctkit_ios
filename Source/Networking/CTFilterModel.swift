//
//  CTFilterModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 10/12/2018.
//

import Foundation


public struct CTFilterModel:Codable {
    public let type:String
    public let fieldname:String
    public let operatorName:String
    public let filterValue:String
    
 
    enum CodingKeys: String, CodingKey {
        case filters = "filters"
        case type = "type"
        case fieldname = "fieldname"
        case operatorName = "operator"
        case filterValue = "filter_value"
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        type = try! container.decode(String.self, forKey: .type)
        fieldname = try! container.decode(String.self, forKey: .fieldname)
        operatorName = try! container.decode(String.self, forKey: .operatorName)
        filterValue = try! container.decode(String.self, forKey: .filterValue)
       
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(fieldname, forKey: .fieldname)
        try container.encode(operatorName, forKey: .operatorName)
        try container.encode(filterValue, forKey: .filterValue)
        
    }
}
