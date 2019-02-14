//
//  CTApiValidationMessage.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 30/10/2018.
//

import Foundation

public enum CTValidationMessageType {
}

public struct CTApiValidationMessage {

    public var field: String
    public var type: String
    public var translatableKey: String
    public var originalMessage: String

    public init(field: String, type: String, translatableKey: String, originalMessage: String) {
        self.field = field
        self.type = type
        self.translatableKey = translatableKey
        self.originalMessage = originalMessage
    }
}
