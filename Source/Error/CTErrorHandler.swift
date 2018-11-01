//
//  CTErrorHandler.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//

import Foundation
import Alamofire

internal class CTErrorHandler: NSObject {
    
    func handle(withDecodingError data: Any?) -> CTErrorProtocol {
        return CTDecodingError(translationKey: "ctkit.error.decoding-failed", description: "Failed to decode object")
    }
    
    func handle(withJSONData data: [String:Any]?) -> CTErrorProtocol {
        var handledError: CTErrorProtocol?
        
        if let unwrappedResponse = data, let httpCode = unwrappedResponse["status"] as? Int {
            switch httpCode {
            case 401:
                handledError = handleUnauthorized(body: unwrappedResponse)
            case 400:
                handledError = handleBadRequest(body: unwrappedResponse)
            case 422:
                handledError = handleUnprocessableEntity(body: unwrappedResponse)
            default:
                handledError = CTBasicError(translationKey: "DEFAULT ERROR HANDLE", description: "")
            }
        }
        
        if let handledError = handledError {
            return handledError
        }
        
        
        return CTBasicError(translationKey: "COULD NOT PARSE", description: "COULD NOT PARSE")
    }
    
    func handle(response: DataResponse<Any>) -> CTErrorProtocol {
        guard let jsonData = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any] else {
            return CTBasicError(translationKey: "COULD NOT PARSE json", description: "")
        }
        
        return self.handle(withJSONData: jsonData)
    }
    
    // Specialized handler functions
    func handleUnauthorized(body: [String:Any]) -> CTBasicError? {
        if let detail = body["detail"] as? String {
            if detail == "Invalid username and password combination" {
                return CTBasicError(translationKey: "api.error.401.invalid-username-password-combination", description: "Invalid username and password combination", code: 401)
            }
        }
        
        return nil
    }
    
    func handleBadRequest(body: [String:Any]) -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.400.bad-request", description: "The server encountered a bad request", errorBody: body)
    }
    
    func handleUnprocessableEntity(body: [String:Any]) -> CTErrorProtocol? {
        if let _ = body["validation_messages"] as? [String:Any] {
            return handleValidationError(body: body)
        }
        
        
        if let detail = body["detail"] as? String {
            switch detail {
            default:
                return handleInvalidFields(body:body)
            }
        }
        
        return nil
    }
    
    func handleValidationError(body: [String:Any]) -> CTValidationError? {
        return CTValidationError(translationKey: "api.error.validation-failed", description: "Failed Validation", errorBody: body, code: 422)
    }
    
    func handleInvalidFields(body: [String:Any]) -> CTBasicError? {
        return CTBasicError(translationKey: body["detail"] as! String, description: "One or more supplied fields are invalid", code: 422)
    }
}
