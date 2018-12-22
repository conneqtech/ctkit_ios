//
//  CTSubscriptionManager.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation
import RxSwift
import Alamofire

public class CTSubscriptionManager {
    private let apiConfig:CTVendorApiConfig
    private let sessionManager:SessionManager
    
    public init(withConfig config:CTVendorApiConfig) {
        self.apiConfig = config
        self.sessionManager = SessionManager()
        sessionManager.adapter = CTRequestAdapter()
        sessionManager.retrier = CTRequestRetrier(apiConfig: self.apiConfig)
    }
    
    public func getSubscriptionForBike(endpoint:String, parameters:[String:Any]? = nil,  useToken:String? = nil) -> Observable<[CTSubscriptionModel]> {
        return genericCall(.get, endpoint: endpoint, parameters: parameters, encoding: URLEncoding.default, useToken: useToken)
    }
    
    public func startTrial(endpoint:String, parameters: [String:Any]? = nil, useToken:String? = nil) -> Observable<CTSubscriptionModel> {
        return genericCall(.post, endpoint: endpoint, parameters: parameters, useToken:useToken)
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
                        //FIXME: Remove debug code
                        do {
                            let _ = try JSONDecoder().decode(T.self, from: response.data!)
                        } catch {
                            print("DEBUG: Decoding gave us the following error")
                            print(error)
                        }
                        //End of debug code
                        
                        guard let data = response.data, let getResponse = try? JSONDecoder().decode(T.self, from: data) else {
                            observer.onError(CTErrorHandler().handle(withDecodingError:nil))
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


