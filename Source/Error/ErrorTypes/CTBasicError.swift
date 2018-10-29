//
//  CTBasicError.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//

import Foundation

public struct CTBasicError: CTErrorProtocol {
    public var type: CTErrorType
    public var code: Int
    
    public var translationKey: String
    public var errorBody: [String: Any]
    
    public var description: String
    
    public init(translationKey: String, description: String, errorBody: [String:Any] = [:], code: Int = 0) {
        self.translationKey = translationKey
        self.description = description
        self.errorBody = errorBody
        self.code = code
        self.type = .basic
    }
}
