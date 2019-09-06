//
//  CTContentResponseModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/09/2019.
//

import Foundation

public struct CTContentResponseModel: CTBaseModel {
    public let content: String

    enum CodingKeys: String, CodingKey {
        case content
    }
}
