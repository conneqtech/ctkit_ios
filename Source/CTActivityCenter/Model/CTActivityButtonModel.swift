//
//  CTButtonModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/07/2019.
//

import Foundation

public struct CTActivityButtonModel: CTBaseModel {
    public let text: String
    public let textArgs: [String]
    public let action: String

    enum CodingKeys: String, CodingKey {
        case text
        case textArgs = "text_args"
        case action
    }
}
