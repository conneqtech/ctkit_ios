//
//  CTRequestRetrier.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 27/09/2018.
//

import Foundation
import Alamofire

class CTRequestRetrier: RequestRetrier {

    private let lock = NSLock()
    private let apiConfig: CTApiConfig

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
                
                guard !self.isRefreshing else { return }

                self.isRefreshing = true
                
                CTKit.shared.authManager.refreshTokens(url: self.apiConfig.fullUrl) {  [weak self] succeeded, tokenResponse in

                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock()}

                    if succeeded, let tokenResponse = tokenResponse {
                        CTKit.shared.authManager.saveTokenResponse(tokenResponse)
                    }

                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0)}
                    strongSelf.requestsToRetry.removeAll()
                    
                    strongSelf.isRefreshing = false
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
}
