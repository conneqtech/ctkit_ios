//
//  CTErrorHandler.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//

import Foundation
import Alamofire

class CTErrorHandler: NSObject {

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
            case 403:
                handledError = handleForbidden(body: unwrappedResponse)
            case 404:
                handledError = handleNotFound(body: unwrappedResponse)
            case 406:
                handledError = handleUserAlreadyTaken(body: unwrappedResponse)
            case 422:
                handledError = handleUnprocessableEntity(body: unwrappedResponse)
            case 500:
                handledError = handleInternalServerError()
            default:
                var detail = "api.error.unhandled.unknown-responsecode"
                var translated = "The response code we received from the API is one we don't handle. Please try again at a later time."
                if let detailFromData = data?["detail"] as? String {
                    detail = detailFromData
                }
                
                if let translatedFromData = data?["error_translatable"] as? String {
                    translated = translatedFromData
                }
                
                handledError = CTBasicError(translationKey: detail,
                                            description: translated,
                                            errorBody: unwrappedResponse,
                                            code: httpCode)
            }
        }
        
        if let handledError = handledError {
            return handledError
        }

        return CTBasicError(translationKey: "api.error.unhandled.unparseable-responsebody",
                            description: "We received an API error that we could not handle. Please try again at a later time")
    }

    func handle(response: DataResponse<Any>, error: Error, url: String) -> CTErrorProtocol {
        if(!Connectivity.isConnectedToInternet){
            return CTErrorHandler().handleNoInternet()
        }
        
        if self.isErrorReportable(error, response: response) {
            var errorInfo = error.getInfoFromResponse(response)
            errorInfo["url"] = url
            NotificationCenter.default.post(name: Notification.Name("logErrorRequest"), object: nil, userInfo: errorInfo)
        }
        
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

    private func isErrorReportable(_ error: Error, response: DataResponse<Any>) -> Bool {

        guard let errorCode = (error as NSError).code as? Int else { return false }
        
        // 422. Alamofire.AFError: Trying to modify a demo account
        // 401. Alamofire.AFError: Unauthorized
        if let innerResponse = response.response, [401, 422].contains(innerResponse.statusCode) {
            return false
        }

        // 53 is https://developer.apple.com/forums/thread/106838 apple bug for iOS 12
        // Rest are network errors:
        // https://developer.apple.com/documentation/foundation/1448136-nserror_codes
        return ![53,
                 Int(CFNetworkErrors.cfurlErrorCancelled.rawValue),
                 Int(CFNetworkErrors.cfurlErrorTimedOut.rawValue),
                 Int(CFNetworkErrors.cfurlErrorCannotFindHost.rawValue),
                 Int(CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue),
                 Int(CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue),
                 Int(CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue),
                 Int(CFNetworkErrors.cfurlErrorCallIsActive.rawValue),
                 Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue),
                 Int(CFNetworkErrors.cfurlErrorSecureConnectionFailed.rawValue)].contains(errorCode)
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

    func handleForbidden(body: [String: Any]) -> CTBasicError? {
        return CTBasicError(translationKey: "api.error.403.forbidden",
                            description: "You are not using the right credentials to make this call",
                            code: 403)
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
    
    func handleNoInternet() -> CTErrorProtocol {
        return CTBasicError(translationKey: "ctkit.error.no-internet", description: "Not connected to the Internet")
    }
    
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        if let manager = NetworkReachabilityManager() {
            return manager.isReachable
        }
        return true
    }
}
