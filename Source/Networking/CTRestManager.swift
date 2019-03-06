//
//  CTRestManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift
import Alamofire

public class CTRestManager {
    private let apiConfig: CTApiConfig
    private let sessionManager: SessionManager

    public init(withConfig config: CTApiConfig) {
        self.apiConfig = config
        self.sessionManager = SessionManager()
        sessionManager.adapter = CTRequestAdapter()
        sessionManager.retrier = CTRequestRetrier(apiConfig: self.apiConfig)
    }

    public func get<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, useToken: String? = nil) -> Observable<T> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, encoding: URLEncoding.default, useToken: useToken)
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
            var headers: [String: String] = [:]

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

            var headers: [String: String] = [:]

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
                    
                    if CTKit.shared.debugMode {
                        print("=========================================")
                        print("🌍[\(method)] \(self.apiConfig.fullUrl)/\(endpoint)")
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
                        }
                        print("=========================================")
                    }

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
}
