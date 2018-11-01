//
//  CTUnregisteredBikeInformationModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 01/11/2018.
//

import Foundation

public class CTUnregisteredBikeInformationModel: CTBaseModel {
    
    public let partialIMEI: String

    //Params
    public let frameNumber:String
    public let manufacturerDescription:String
    public let manufacturerSKU:String
    public let manufacturerModelName:String
    public let manufacturerProductionDate:String
    
    enum CodingKeys: String, CodingKey {
        case partialIMEI = "imei_first_digits"
        case params = "params"
        case frameNumber = "frame_number"
        case manufacturerDescription = "art_descr"
        case manufacturerSKU = "art_num"
        case manufacturerModelName = "model_name"
        case manufacturerProductionDate = "fabrication_date"
    }
    
    required public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let params = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .params)
        
        partialIMEI = try! container.decode(String.self, forKey: .partialIMEI)
        
        frameNumber = try params.decode(String.self, forKey: .frameNumber)
        manufacturerDescription = try params.decode(String.self, forKey: .manufacturerDescription)
        manufacturerSKU = try params.decode(String.self, forKey: .manufacturerSKU)
        manufacturerModelName = try params.decode(String.self, forKey: .manufacturerModelName)
        manufacturerProductionDate = try params.decode(String.self, forKey: .manufacturerProductionDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var params = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .params)
        
        
        try container.encode(partialIMEI, forKey: .partialIMEI)
       
        try params.encode(frameNumber, forKey: .frameNumber)
        try params.encode(manufacturerDescription, forKey: .manufacturerDescription)
        try params.encode(manufacturerSKU, forKey: .manufacturerSKU)
        try params.encode(manufacturerModelName, forKey: .manufacturerModelName)
        try params.encode(manufacturerProductionDate, forKey: .manufacturerProductionDate)
    }
}
