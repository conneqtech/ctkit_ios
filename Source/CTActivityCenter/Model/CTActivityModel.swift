//
//  CTActivityModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/07/2019.
//

import Foundation

public struct CTActivtyModel: CTBaseModel {

    public let id: String

    public let header: String
    public let headerArgs: [String]

    public let subHeader: String
    public let subHeaderArgs: [String]

    public let text: String?
    public let textArgs: [String]

    public let button: CTActivityButtonModel?
    public let iconUrl: String?

    public let isFeatured: Bool
    public let isDismissable: Bool

    public let language: String?
    public let creationDate: Date

    enum CodingKeys: String, CodingKey {
        case id

        case header
        case headerArgs = "header_args"

        case subHeader = "sub_header"
        case subHeaderArgs = "sub_header_args"

        case text
        case textArgs = "text_args"

        case button
        case iconUrl = "icon_url"

        case isFeatured = "is_featured"
        case isDismissable = "is_dismissable"

        case language
        case creationDate = "creation_date"
    }
    
}
