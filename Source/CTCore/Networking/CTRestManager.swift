//
//  CTRestManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift
import Alamofire
import UIKit

public class CTRestManager {
    private let apiConfig: CTApiConfig
    private let sessionManager: SessionManager

    public init(withConfig config: CTApiConfig) {
        self.apiConfig = config
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSMutableURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        self.sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = CTRequestAdapter()
        sessionManager.retrier = CTRequestRetrier(apiConfig: self.apiConfig)
    }

    public init(withConfig config: CTApiConfig, requestAdapter: RequestAdapter, requestRetrier: RequestRetrier) {
        self.apiConfig = config
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSMutableURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        self.sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = requestAdapter
        sessionManager.retrier = requestRetrier
    }

    public func get<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil, additionalHeaders: [String: String]? = nil) -> Observable<T> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, encoding: URLEncoding.default, useToken: useToken)
    }

    public func getGenericUrl<T: Codable>(url: String, parameters: [String: Any]? = nil, useToken: String? = nil, additionalHeaders: [String: String]? = nil) -> Observable<T> {
        return genericCallWithUrl(.get, url: url, parameters: parameters, encoding: URLEncoding.default, useToken: useToken, additionalHeaders: additionalHeaders)
    }
    
    public func postCompletable(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Completable {
        return genericCompletableCall(.post, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }

    public func post<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<T> {
        return genericCall(.post, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }
    
    public func post(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil, callBack: (() -> ())? = nil) {
        return genericCallbackCall(.post, endpoint: endpoint, parameters: parameters, useToken: useToken, callBack: callBack)
    }

    public func patch<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<T> {
        return genericCall(.patch, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }

    public func delete(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Completable {
        return genericCompletableCall(.delete, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }

    public func archive<T: Codable>(endpoint: String, useToken: String? = nil) -> Observable<T> {
        return genericCall(
            .patch,
            endpoint: endpoint,
            parameters: ["active_state": 2],
            useToken: useToken
            )
    }

    public func upload<T: Codable>(endpoint: String, image: UIImage, useToken: String? = nil) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            if (!Connectivity.isConnectedToInternet) {
                observer.onError(CTErrorHandler().handleNoInternet())
                return Disposables.create()
            }
            var headers: [String: String] = [:]
            
            if let accessToken = useToken {
                headers["Authorization"] = "\(CTKit.shared.authManager.getTokenType()) \(accessToken)"
            }

            let url = URL(string: "\(self.apiConfig.fullUrl)/\(endpoint)")!
            Alamofire.upload(multipartFormData: { formData in
                if let fixedOrientation = image.fixedOrientation(), let imageData = fixedOrientation.pngData() {
                    formData.append(imageData, withName: "file", fileName: "file.png", mimeType: "image/png")
                }
            }, to: url, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload
                        .validate(statusCode: 200..<300)
                        .validate(contentType: ["application/json"])
                        .responseJSON { response in
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(.iso8601CT)
                            switch response.result {
                            case .success:
                                guard let data = response.data, let getResponse = try? decoder.decode(T.self, from: data) else {
                                    observer.onError(CTErrorHandler().handle(withDecodingError: nil))
                                    return
                                }

                                observer.onNext(getResponse)
                                observer.onCompleted()

                            case .failure(let error):
                                observer.onError(CTErrorHandler().handle(response: response, error: error, url: url.absoluteString))
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    observer.onError(CTBasicError(translationKey: "api.error.upload.failed", description: "Uploading failed"))
                }
            })

            return Disposables.create(with: {

            })
        }
    }

    func genericCompletableCall(_ method: Alamofire.HTTPMethod, endpoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?, url: String? = nil) -> Completable {
        
        return Completable.create { (completable) in
            
            if (!Connectivity.isConnectedToInternet) {
                completable(.error(CTErrorHandler().handleNoInternet()))
                return Disposables.create()
            }
            var headers: [String: String] = self.computeHeaders()!

            if let accessToken = useToken {
                headers["Authorization"] = "\(CTKit.shared.authManager.getTokenType()) \(accessToken)"
            }

            var rootUrl = self.apiConfig.fullUrl
            if let forcedUrl = url {
                rootUrl = forcedUrl
            }
            
            let url = URL(string: "\(rootUrl)/\(endpoint)")!
            let requestReference = self.sessionManager.request(url,
                                                               method: method,
                                                               parameters: parameters,
                                                               encoding: encoding,
                                                               headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(CTErrorHandler().handle(response: response, error: error, url: url.absoluteString)))
                    }
            }

            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }

    private func genericCall<T>(_ method: Alamofire.HTTPMethod, endpoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Observable<T> where T: Codable {
            return Observable<T>.create { (observer) -> Disposable in
                
                if (!Connectivity.isConnectedToInternet) {
                    observer.onError(CTErrorHandler().handleNoInternet())
                    return Disposables.create()
                }
                
                var headers: [String: String] = self.computeHeaders()!

                if let accessToken = useToken {
                    headers["Authorization"] = "\(CTKit.shared.authManager.getTokenType()) \(accessToken)"
                }
                
                let url = URL(string: "\(self.apiConfig.fullUrl)/\(endpoint)")!
                let requestReference = self.sessionManager.request(url,
                                                                   method: method,
                                                                   parameters: parameters,
                                                                   encoding: encoding,
                                                                   headers: headers)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseJSON { (response) in
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601CT)

                        self.responseDebugger(method, endpoint: endpoint, url: url.absoluteString, parameters: parameters, response: response, decodeType: T.self)

                        switch response.result {
                        case .success:
                            guard let data = response.data, let getResponse = try? decoder.decode(T.self, from: data) else {
                                observer.onError(CTErrorHandler().handle(withDecodingError: nil))
                                return
                            }
                            observer.onNext(getResponse)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(CTErrorHandler().handle(response: response, error: error, url: url.absoluteString))
                        }
                }

                return Disposables.create(with: {
                    requestReference.cancel()
                })
            }
    }

    private func genericCallWithUrl<T>(_ method: Alamofire.HTTPMethod, url: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?, additionalHeaders: [String: String]? = nil) -> Observable<T> where T: Codable {
            return Observable<T>.create { (observer) -> Disposable in
                var headers = additionalHeaders

                if let accessToken = useToken {
                    headers?["Authorization"] = "\(CTKit.shared.authManager.getTokenType()) \(accessToken)"
                }

                let requestReference = self.sessionManager.request(url,
                                                                   method: method,
                                                                   parameters: parameters,
                                                                   encoding: encoding,
                                                                   headers: headers)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .responseJSON { (response) in
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601CT)

                        self.responseDebugger(method, endpoint: "", url: url, parameters: parameters, response: response, decodeType: T.self)

                        switch response.result {
                        case .success:
                            guard let data = response.data, let getResponse = try? decoder.decode(T.self, from: data) else {
                                observer.onError(CTErrorHandler().handle(withDecodingError: nil))
                                return
                            }
                            observer.onNext(getResponse)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(CTErrorHandler().handle(response: response, error: error, url: url))
                        }
                }

                return Disposables.create(with: {
                    requestReference.cancel()
                })
            }
    }
    
    
    private func genericCallbackCall(_ method: Alamofire.HTTPMethod, endpoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?, callBack: (() -> ())? = nil) {
        
        var headers: [String: String] = self.computeHeaders()!

        let url = URL(string: "\(self.apiConfig.fullUrl)/\(endpoint)")!
        let requestReference = self.sessionManager.request(url,
                                                           method: method,
                                                           parameters: parameters,
                                                           encoding: encoding,
                                                           headers: headers)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { (response) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.iso8601CT)
            switch response.result {
            case .success:
                callBack?()
                break
            case .failure(let error):
                var userInfo = error.getInfoFromResponse(response)
                userInfo["url"] = url.absoluteString
                CTErrorHandler().handle(response: response, error: error, url: url.absoluteString)
                print("ERROR: \(response)")
                callBack?()
                break
            }
        }
    }
}

// MARK: - Request helper functions
fileprivate extension CTRestManager {
    func computeHeaders() -> [String:String]? {
        var headers:[String:String] = Alamofire.SessionManager.defaultHTTPHeaders

        var language = "en"
        if let currentLanguage = UserDefaults.standard.object(forKey: "LCLCurrentLanguageKey") as? String {
            language = currentLanguage
        }

        headers["X-Device-Platform"]            = "ios"
        headers["X-Device-Platform-Version"]    = UIDevice.systemVersion()
        headers["X-Device-Name"]                = UIDevice.deviceName()
        headers["X-Device-Model"]               = UIDevice.deviceModelReadable()
        headers["X-Device-App-Identifier"]      = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
        headers["X-Device-App-Build"]           = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        headers["X-Device-App-Version"]         = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        headers["X-Device-App-Language"]        = language
        headers["X-Device-Language"]            = UIDevice.deviceLanguage()
        headers["X-Device-Timezone"]            = NSTimeZone.system.identifier

        return headers
    }

    func responseDebugger<T>(_ method: Alamofire.HTTPMethod,
                             endpoint: String,
                             url: String? = nil,
                             parameters: [String: Any]? = nil,
                             response: DataResponse<Any>,
                             decodeType: T.Type) where T: Codable {
        if !CTKit.shared.debugMode {
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601CT)

        print(".=========================================.")
        if let unwrappedUrl = url {
            print("🌍[\(method)] \(unwrappedUrl)")
        } else {
            print("🌍[\(method)] \(self.apiConfig.fullUrl)/\(endpoint)")
        }
        
        if let parameters = parameters {
            print("📄 Parameters:")
            print(parameters)
        }

        if let rData = response.data {
            print("♻️ Response with \(rData.count) bytes")

            if response.result.isFailure {
                print("⚠️ The call failed with the following error")
            } else {
                print("✅ The call succeeded with the following data")
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: rData, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }

            print("=-=-=-=-=-=-=-=-=-=-=-=-=-=")
            do {
                _ = try decoder.decode(decodeType, from: rData)
                print("✅ Parsing success")
            } catch let modelParsingError {
                print("🚒 Parsing failed")
                print(modelParsingError)
            }
            print("=-=-=-=-=-=-=-=-=-=-=-=-=-=")
        }
        print(".=========================================.")
    }
}
