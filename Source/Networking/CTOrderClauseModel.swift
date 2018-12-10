//
//  CTOrderClauseModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 10/12/2018.
//

import Foundation

public struct CTOrderClauseModel:Codable {
    public let fieldname:String
    public let order:String
    
    
    
    enum CodingKeys: String, CodingKey {
        case fieldname = "fieldname"
        case order = "order"
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fieldname = try! container.decode(String.self, forKey: .fieldname)
        order = try! container.decode(String.self, forKey: .order)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(fieldname, forKey: .fieldname)
        try container.encode(order, forKey: .order)
        
    }
}
