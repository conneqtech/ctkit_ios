//
//  CTProductTypeModel.swift
//  Alamofire
//
//  Created by De backer Klaartje on 29/01/2020.
//

import Foundation

public struct CTProductTypesModel: CTBaseModel {
    
    public let productTypes :[CTProductTypeModel]
    enum CodingKeys: String, CodingKey {
        case productTypes = "product_types"
    }
}

public struct CTProductTypeModel: CTBaseModel {
    
    public let startDate :Date
    public let endDate :Date
    public let cancelled :Bool
    public let productTypeId :String?
    public let insurance :CTInsuranceModel
    
    enum CodingKeys: String, CodingKey {
        
        case startDate = "start_date"
        case endDate = "end_date"
        case cancelled
        case productTypeId = "product_type_id"
        case insurance
    }
}
