//
//  CTUnregisteredBikeInformationModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 01/11/2018.
//

import Foundation

public struct CTUnregisteredBikeInformationModel: CTBaseModel {

    /// Partial IMEI number the use as a textual hint for the user to input the full IMEI.
    public let partialIMEI: String

    /// The frame number of a bike. The combination of frame_number and imei is needed to register a bike in the bike api. It acts as a second factor authentication during the bike registration process. Without this parameter, bikes cannot be registered by end-users.
    public let frameNumber: String

    /// The SKU of the bike. When one of the Conneqtech Services must identify the bike type for e.g turning functionality on/off, this parameter will most likely be used
    public let manufacturerSKU: String?

    /// Human readable name of the bike model. Acts as a meta field which can be shown in apps or administrative services.
    public let manufacturerModelName: String?

    public let registrationFlow: CTBikeRegistrationFlow

    enum CodingKeys: String, CodingKey {
        case partialIMEI = "imei_first_digits"
        case frameNumber = "frame_number"
        case manufacturerSKU = "art_num"
        case manufacturerModelName = "model_name"
        case registrationFlow = "registration_flow"
    }

    public init(partialIMEI: String, frameNumber: String, manufacturerSKU: String?, modelName: String?, registrationFlow: CTBikeRegistrationFlow) {
        self.partialIMEI = partialIMEI
        self.frameNumber = frameNumber
        self.manufacturerSKU = manufacturerSKU
        self.manufacturerModelName = modelName
        self.registrationFlow = registrationFlow
    }
}
