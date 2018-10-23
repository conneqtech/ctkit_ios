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
    private let apiConfig:CTApiConfig
    private let sessionManager:SessionManager
    
    public init(withConfig config:CTApiConfig) {
        self.apiConfig = config
        self.sessionManager = SessionManager()
        sessionManager.adapter = CTRequestAdapter()
        sessionManager.retrier = CTRequestRetrier(apiConfig: self.apiConfig)
    }
    
    public func get<T:Codable, E:CTErrorProtocol>(endpoint:String, parameters:[String:Any]? = nil,  useToken:String? = nil) -> Observable<CTResult<T, E>> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, encoding: URLEncoding.default, useToken: useToken)
    }
    
    public func post<T:Codable, E:CTErrorProtocol>(endpoint:String, parameters: [String:Any]? = nil, useToken:String? = nil) -> Observable<CTResult<T, E>> {
        return genericCall(.post, endpoint: endpoint, parameters: parameters, useToken:useToken)
    }
    
    public func patch<T:Codable, E:CTErrorProtocol>(endpoint:String, parameters: [String:Any]? = nil,  useToken:String? = nil) -> Observable<CTResult<T, E>> {
        return genericCall(.patch, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }
    
    public func delete(endpoint:String, parameters: [String:Any]? = nil, useToken:String? = nil) -> Completable  {
        return genericCompletableCall(.delete, endpoint: endpoint, parameters: parameters, useToken:useToken)
    }
    
    public func archive(endpoint:String, useToken:String? = nil) -> Completable {
        return genericCompletableCall(.patch, endpoint: endpoint, parameters: ["active_state":2], useToken:useToken)
    }
    
    private func genericCompletableCall(_ method: Alamofire.HTTPMethod, endpoint: String, parameters:[String:Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Completable {
        return Completable.create { (completable) in
            var headers: [String:String] = [:]
            
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
    
    private func genericCall<T:Codable, E:CTErrorProtocol>(_ method: Alamofire.HTTPMethod, endpoint: String, parameters:[String:Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Observable<CTResult<T, E>> {
        return Observable<CTResult<T, E>>.create { (observer) -> Disposable in
            
            var headers: [String:String] = [:]
            
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
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(T.self, from: data) else {
                            observer.onError(NSError(domain: "test", code: 400, userInfo: nil))
                            return
                        }
                    
                        observer.onNext(CTResult.success(getResponse))
                        observer.onCompleted()
                    case .failure:
//                        CTResult.failure(CTErrorHandler().handle(response: response))l
                        let error = CTErrorHandler().handle(response: response)
                        observer.onNext(CTResult.failure(error as! E)) //FIXME: WHAT? NOW? Why would we need the forcecast if it assumes the protocol?
                        observer.onCompleted()
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
}
