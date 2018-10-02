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
    
    public func get<T:Codable>(endpoint:String, parameters:[String:Any]? = nil,  useToken:String? = nil) -> Observable<T> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }
    
    public func post<T:Codable>(endpoint:String, parameters: [String:Any]? = nil, useToken:String? = nil) -> Observable<T> {
        return genericCall(.post, endpoint: endpoint, parameters: parameters, useToken:useToken)
    }
    
    public func patch<T:Codable>(endpoint:String, parameters: [String:Any]? = nil,  useToken:String? = nil) -> Observable<T> {
        return genericCall(.patch, endpoint: endpoint, parameters: parameters, useToken: useToken)
    }
    
    public func delete<T:Codable>(endpoint:String, parameters: [String:Any]? = nil, useToken:String? = nil) -> Observable<T>  {
        return genericCall(.delete, endpoint: endpoint, parameters: parameters, useToken:useToken)
    }
    
    private func genericCall<T>(_ method: Alamofire.HTTPMethod, endpoint: String, parameters:[String:Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, useToken: String?) -> Observable<T> where T:Codable {
        return Observable<T>.create { (observer) -> Disposable in
            
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
                        do {
                            let getResponse = try JSONDecoder().decode(T.self, from: response.data!)
                        } catch {
                            print("GECATCHED")
                            print(error)
                        }
                            guard let data = response.data, let getResponse = try?JSONDecoder().decode(T.self, from: data) else {
                                print(T.self)
                                observer.onError(NSError(domain: "test", code: 400, userInfo: nil))
                                return
                            }
                        
                        
                        
                        observer.onNext(getResponse)
                        observer.onCompleted()
                    case .failure:
                        observer.onError(response.error!)
                    }
            }
            
            return Disposables.create(with: {
                requestReference.cancel()
            })
        }
    }
}
