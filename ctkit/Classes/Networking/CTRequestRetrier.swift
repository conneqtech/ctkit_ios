//
//  CTRequestRetrier.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 27/09/2018.
//

import Foundation
import Alamofire

class CTRequestRetrier: RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ tokenResponse: CTOAuth2TokenResponse?) -> Void
    
    private let lock = NSLock()
    private let apiConfig:CTApiConfig
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    init(apiConfig: CTApiConfig) {
        self.apiConfig = apiConfig
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, tokenResponse in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock()}
                    
                    if let tokenResponse = tokenResponse {
                        CTBike.shared.authManager.saveTokenResponse(tokenResponse)
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0)}
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        let urlString = "\(apiConfig.fullUrl)/oauth"
        
        let params: [String:Any] = [
            "refresh_token": CTBike.shared.authManager.getRefreshToken(),
            "client_id":apiConfig.clientId,
            "client_secret":apiConfig.clientSecret,
            "grant_type":"refresh_token"
        ]
        
        let _ = Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                guard let data = response.data, let getResponse = try? JSONDecoder().decode(CTOAuth2TokenResponse.self, from: data) else {
                    completion(false, nil)
                    return
                }
                
                completion(true, getResponse)
                strongSelf.isRefreshing = false
        }
    }
}
