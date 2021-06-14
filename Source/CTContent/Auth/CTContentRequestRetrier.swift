//
//  CTContentRequestRetrier.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/09/2019.
//

import Foundation
import Alamofire
import RxSwift

public class CTContentRequestRetrier: RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ tokenResponse: CTCredentialResponse?) -> Void

    private let lock = NSLock()

    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    var disposeBag = DisposeBag()

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        if let _ = CTKit.shared.idsAuthManager {
            return
        }
        
        self.lock.lock() ; defer { self.lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            
            self.requestsToRetry.append(completion)

            if self.isRefreshing {
                return
            }

            self.refreshTokens { [weak self] succeeded, tokenResponse in
                
                guard let strongSelf = self else { return }

                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock()}

                if succeeded, let tokenResponse = tokenResponse {
                    CTContent.shared.authManager.saveTokenResponse(tokenResponse)
                }

                strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0)}
                strongSelf.requestsToRetry.removeAll()
            }
        } else {
            completion(false, 0.0)
        }
    }

    private func refreshTokens(completion: @escaping RefreshCompletion) {

        self.isRefreshing = true

        CTJwtService().getJwtForContentAPI().subscribe(onNext: { [weak self] jwtToken in
            guard let strongSelf = self else { return }

            completion(true, CTCredentialResponse(accessToken: jwtToken,
                                                  refreshToken: nil,
                                                  expiresIn: 3600 * 4,
                                                  scope: nil,
                                                  tokenType: "jwt")
            )
            strongSelf.isRefreshing = false
            }, onError: { _ in
                completion(false, nil)
                self.isRefreshing = false
        }).disposed(by: disposeBag)
    }
}
