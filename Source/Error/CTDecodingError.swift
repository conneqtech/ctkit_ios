//
//  CTDecodingError.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//

import Foundation

struct CTDecodingError: CTErrorProtocol {
    var code: Int
    
    var translationKey: String
    var errorBody: [String: Any]
    
    var description: String
    
    init(translationKey: String, description: String, errorBody: [String:Any] = [:], code: Int = 0) {
        self.translationKey = translationKey
        self.description = description
        self.errorBody = errorBody
        self.code = code
    }
}
