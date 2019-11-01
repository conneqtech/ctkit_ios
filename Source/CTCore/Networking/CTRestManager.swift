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
        self.sessionManager = SessionManager()
        sessionManager.adapter = CTRequestAdapter()
        sessionManager.retrier = CTRequestRetrier(apiConfig: self.apiConfig)
    }

    public init(withConfig config: CTApiConfig, requestAdapter: RequestAdapter, requestRetrier: RequestRetrier) {
        self.apiConfig = config
        self.sessionManager = SessionManager()
        sessionManager.adapter = requestAdapter
        sessionManager.retrier = requestRetrier
    }

    public func get<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<T> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, encoding: URLEncoding.default, useToken: useToken)
    }

    public func getUnparsed(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<String> {
        return genericUnparsedCall(.get, endpoint: endpoint, useToken: useToken)
    }

    public func post<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<T> {
        return genericCall(.post, endpoint: endpoint, parameters: parameters, useToken: useToken)
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
            
            if let bearer = useToken {
                headers["Authorization"] = "Bearer \(bearer)"
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

                            case .failure:
                                observer.onError(CTErrorHandler().handle(response: response))
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

    private func genericCompletableCall(_ method: Alamofire.HTTPMethod, endpoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Completable {
        return Completable.create { (completable) in
            if (!Connectivity.isConnectedToInternet) {
                completable(.error(CTErrorHandler().handleNoInternet()))
                return Disposables.create()
            }
            var headers: [String: String] = self.computeHeaders()!

            if let bearer = useToken {
                headers["Authorization"] = "Bearer \(bearer)"
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
                    switch response.result {
                    case .success:
                        completable(.completed)
                    case .failure:
                        completable(.error(CTErrorHandler().handle(response: response)))
                    }
            }

            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }

    private func genericCall<T>(_ method: Alamofire.HTTPMethod, endpoint: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Observable<T> where T: Codable {
        
            return Observable<T>.create { (observer) -> Disposable in

                if(!Connectivity.isConnectedToInternet){
                    observer.onError(CTErrorHandler().handleNoInternet())
                    return Disposables.create()
                }

                var headers: [String: String] = self.computeHeaders()!

                if let bearer = useToken {
                    headers["Authorization"] = "Bearer \(bearer)"
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

                        self.responseDebugger(method, endpoint: endpoint, parameters: parameters, response: response, decodeType: T.self)

                        switch response.result {
                        case .success:
                            guard let data = response.data, let getResponse = try? decoder.decode(T.self, from: data) else {
                                observer.onError(CTErrorHandler().handle(withDecodingError: nil))
                                return
                            }

                            observer.onNext(getResponse)
                            observer.onCompleted()
                        case .failure:
                            observer.onError(CTErrorHandler().handle(response: response))
                        }
                }

                return Disposables.create(with: {
                    requestReference.cancel()
                })
            }
    }

    private func genericUnparsedCall(_ method: Alamofire.HTTPMethod,
                                     endpoint: String,
                                     parameters: [String: Any]? = nil,
                                     encoding: ParameterEncoding = JSONEncoding.default,
                                     useToken: String?) -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in

            if(!Connectivity.isConnectedToInternet) {
                observer.onError(CTErrorHandler().handleNoInternet())
                return Disposables.create()
            }

            var headers: [String: String] = self.computeHeaders()!

            if let bearer = useToken {
                headers["Authorization"] = "Bearer \(bearer)"
            }

            let url = URL(string: "\(self.apiConfig.fullUrl)/\(endpoint)")!
            let requestReference = self.sessionManager.request(url,
                                                               method: method,
                                                               parameters: parameters,
                                                               encoding: encoding,
                                                               headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { (response) in

                if response.result.isSuccess {
                    if let result = response.result.value {
                        observer.onNext(result)
                    } else {
                        observer.onNext("")
                    }

                    observer.onCompleted()
                } else {
                    observer.onError(response.error!) //CTErrorHandler().handle(response: response)
                }
            }

            return Disposables.create(with: {
                requestReference.cancel()
            })
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
                             parameters: [String: Any]? = nil,
                             response: DataResponse<Any>,
                             decodeType: T.Type) where T: Codable {
        if !CTKit.shared.debugMode {
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601CT)

        print(".=========================================.")
        print("🌍[\(method)] \(self.apiConfig.fullUrl)/\(endpoint)")
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
