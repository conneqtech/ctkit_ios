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

    // Note: we need this init for testing purposes
    public init(
        id: String = "",
        header: String = "",
        headerArgs: [String] = [],
        subHeader: String = "",
        subHeaderArgs: [String],
        text: String? = nil,
        textArgs: [String],
        button: CTActivityButtonModel? = nil,
        iconUrl: String? = nil,
        isFeatured: Bool = false,
        isDismissable: Bool = true,
        language: String? = nil,
        creationDate: Date = Date()
    
    ) {
        self.id = id
        self.header = header
        self.headerArgs = headerArgs
        self.subHeader = subHeader
        self.subHeaderArgs = subHeaderArgs
        self.text = text
        self.textArgs = textArgs
        self.button = button
        self.iconUrl = iconUrl
        self.isFeatured = isFeatured
        self.isDismissable = isDismissable
        self.language = language
        self.creationDate = creationDate
    }
    
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
