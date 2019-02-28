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

    func handle(withJSONData data: [String: Any]?) -> CTErrorProtocol {
        var handledError: CTErrorProtocol?

        if let unwrappedResponse = data, let httpCode = unwrappedResponse["status"] as? Int {
            switch httpCode {
            case 400:
                handledError = handleBadRequest(body: unwrappedResponse)
            case 401:
                handledError = handleUnauthorized(body: unwrappedResponse)
            case 404:
                handledError = handleNotFound(body: unwrappedResponse)
            case 406:
                handledError = handleUserAlreadyTaken(body: unwrappedResponse)
            case 422:
                handledError = handleUnprocessableEntity(body: unwrappedResponse)
            case 500:
                handledError = handleInternalServerError()
            default:
                handledError = CTBasicError(translationKey: "api.error.unhandled.unknown-responsecode",
                                            description: "The response code we received from the API is one we don't handle. Please try again at a later time.")
            }
        }

        if let handledError = handledError {
            return handledError
        }

        return CTBasicError(translationKey: "api.error.unhandled.unparseable-responsebody",
                            description: "We received an API error that we could not handle. Please try again at a later time")
    }

    func handle(response: DataResponse<Any>) -> CTErrorProtocol {
        guard let jsonData = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] else {
            var responseDict = [String: Any]()
            if let response = response.response {
                responseDict = [
                    "status": response.statusCode
                    ]
            }
            return self.handle(withJSONData: responseDict)
        }

        return self.handle(withJSONData: jsonData)
    }

    // Specialized handler functions
    func handleUnauthorized(body: [String: Any]) -> CTBasicError? {
        if let detail = body["detail"] as? String {
            if detail == "Invalid username and password combination" {
                return CTBasicError(translationKey: "api.error.401.invalid-username-password-combination",
                                    description: "Invalid username and password combination",
                                    code: 401)
            }
        }
        
        // Handle all 401 the same. It means the user is not logged in
        return CTBasicError(translationKey: "api.error.401.user-not-logged-in",
                               description: "User is not logged in",
                               code: 401)
    }

    func handleNotFound(body: [String: Any]) -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.404.not-found",
                            description: "Requested entity was not found",
                            errorBody: body)
    }

    func handleBadRequest(body: [String: Any]) -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.400.bad-request",
                            description: "The server encountered a bad request",
                            errorBody: body)
    }

    func handleUserAlreadyTaken(body: [String: Any]) -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.406.username-already-taken",
                            description: "This username is already taken",
                            errorBody: body)
    }

    func handleUnprocessableEntity(body: [String: Any]) -> CTErrorProtocol? {
        if let _ = body["validation_messages"] as? [String: Any] {
            return handleValidationError(body: body)
        }

        if let detail = body["detail"] as? String {
            switch detail {
            default:
                return handleInvalidFields(body: body)
            }
        }

        return nil
    }

    func handleValidationError(body: [String: Any]) -> CTValidationError? {
        return CTValidationError(translationKey: "api.error.validation-failed",
                                 description: "Failed Validation",
                                 errorBody: body,
                                 code: 422)
    }

    func handleInvalidFields(body: [String: Any]) -> CTBasicError? {

        var translatable = "One or more supplied fields are invalid"

        if let responseTranslatable = body["error_translatable"] as? String {
            translatable = responseTranslatable
        }

        return CTBasicError(translationKey: body["detail"] as! String, description: translatable, code: 422)
    }

    func handleInternalServerError() -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.500.internal-server-error", description: "Internal server error", code: 500)
    }
}
