//
//  CTUnregisteredBikeInformationModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 01/11/2018.
//

import Foundation

public struct CTUnregisteredBikeModel: CTBaseModel {

    /// Partial IMEI number the use as a textual hint for the user to input the full IMEI.
    public let partialIMEI: String

    /// The frame number of a bike.
    public let frameNumber: String

    // The activation code of a bike. The combination of activationCode and imei is needed to register a bike in the bike api. It acts as a second factor authentication during the bike registration process. Without this parameter, bikes cannot be registered by end-users.
    public let activationCode: String

    /// The article description of a bike. Similar to the model name, could supply more detailed information about a bike, like its color and minor specifications. though is encourage to be kept short. e.g: bike model name matte grey autom. light
    public let manufacturerDescription: String?

    /// The SKU of the bike. When one of the Conneqtech Services must identify the bike type for e.g turning functionality on/off, this parameter will most likely be used
    public let manufacturerSKU: String?

    /// Human readable name of the bike model. Acts as a meta field which can be shown in apps or administrative services.
    public let manufacturerModelName: String?

    /// String representation of the fabrication date in yyy-mm-dd format. also acts as a meta field.
    public let manufacturerProductionDate: String?
    
    /// Optional email address if the user has already added the bike to a different email address
    public let email: String?

    public let bikeTypeId: Int

    enum CodingKeys: String, CodingKey {
        case partialIMEI = "imei_first_digits"
        case params = "params"
        case frameNumber = "frame_number"
        case activationCode = "activation_code"
        case manufacturerDescription = "art_descr"
        case manufacturerSKU = "art_num"
        case manufacturerModelName = "model_name"
        case manufacturerProductionDate = "fabrication_date"
        case bikeTypeId = "bike_type_id"
        case email = "email"
    }

    public init(partialIMEI: String, frameNumber: String, manufacturerSKU: String, modelName: String?, registrationFlow: CTBikeRegistrationFlow) {
        self.partialIMEI = partialIMEI
        self.frameNumber = frameNumber
        self.activationCode = ""
        self.manufacturerDescription = ""
        self.manufacturerSKU = manufacturerSKU
        self.manufacturerModelName = modelName
        self.manufacturerProductionDate = ""
        self.bikeTypeId = -1
        self.email = nil
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let params = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .params)

        partialIMEI = try container.decode(String.self, forKey: .partialIMEI)
        bikeTypeId = try container.decode(Int.self, forKey: .bikeTypeId)

        frameNumber = try params.decode(String.self, forKey: .frameNumber)
        activationCode = try params.decode(String.self, forKey: .activationCode)
        manufacturerDescription = try? params.decode(String.self, forKey: .manufacturerDescription)
        manufacturerSKU = try? params.decode(String.self, forKey: .manufacturerSKU)
        manufacturerModelName = try? params.decode(String.self, forKey: .manufacturerModelName)
        manufacturerProductionDate = try? params.decode(String.self, forKey: .manufacturerProductionDate)
        
        email = try? params.decode(String.self, forKey: .email)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var params = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .params)

        try container.encode(partialIMEI, forKey: .partialIMEI)

        try params.encode(frameNumber, forKey: .frameNumber)
        try params.encode(activationCode, forKey: .activationCode)
        try params.encode(manufacturerDescription, forKey: .manufacturerDescription)
        try params.encode(manufacturerSKU, forKey: .manufacturerSKU)
        try params.encode(manufacturerModelName, forKey: .manufacturerModelName)
        try params.encode(manufacturerProductionDate, forKey: .manufacturerProductionDate)
    }
}
