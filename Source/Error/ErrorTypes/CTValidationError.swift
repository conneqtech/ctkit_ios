//
//  CTValidationError.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 29/10/2018.
//

import Foundation

public class CTValidationError: CTErrorProtocol {
    public var type: CTErrorType
    public var code: Int
    
    public var translationKey: String
    
    public var errorBody: [String : Any]
    
    public var description: String
    
    public var validationMessages: [CTApiValidationMessage] = []
    
    public init(translationKey: String, description: String, errorBody: [String:Any] = [:], code: Int = 0) {
        self.translationKey = translationKey
        self.description = description
        self.errorBody = errorBody
        self.code = code
        self.type = .validation
        
        if let validationMessages = errorBody["validation_messages"] as? [String:Any] {
            for (field, value) in validationMessages {
                if let value = value as? [String:Any] {
                    for (type, subvalue) in value {
                        let message = CTApiValidationMessage(
                            field: field,
                            type: type,
                            translatableKey: "dummy",
                            originalMessage: subvalue as! String
                        )
                        self.validationMessages.append(message)
                    }
                }
            }
        }
    }
}
