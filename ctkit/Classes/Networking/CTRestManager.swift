//
//  CTRestManager.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift
import Alamofire

class AccessTokenAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        print(CTBike.shared.authManager.getAccesToken());
        let accessToken = CTBike.shared.authManager.getAccesToken();
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}


public class CTRestManager {

    private let apiConfig:CTApiConfig
    private let sessionManager:SessionManager
    
    public init(withConfig config:CTApiConfig) {
        self.apiConfig = config
        self.sessionManager = SessionManager()
        sessionManager.adapter = AccessTokenAdapter()
    }
    
    public func get<T>(endpoint:String, parameters:[String:Any]?) -> Observable<T> where T:Codable {
        return Observable<T>.create { (observer) -> Disposable in
            let url = URL(string: "\(self.apiConfig.fullUrl)/\(endpoint)")!
            let requestReference = self.sessionManager.request(url,
                                            method: .get,
                                            parameters: parameters)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data, let getResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        observer.onError(response.error!)
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
    
    public func post<T, U:Codable>(endpoint:String, data: U) -> Observable<T> where T:Codable {
        return Observable.empty()
    }
}
