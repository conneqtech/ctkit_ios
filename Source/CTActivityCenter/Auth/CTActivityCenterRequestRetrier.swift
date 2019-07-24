//
//  CTActivityCenterRequestRetrier.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import Alamofire
import RxSwift

public class CTActivityCenterRequestRetrier: RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ tokenResponse: CTOAuth2TokenResponse?) -> Void

    private let lock = NSLock()

    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    var disposeBag = DisposeBag()

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [weak self] succeeded, tokenResponse in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock()}

                    if succeeded, let tokenResponse = tokenResponse {
                        print("✅ Saving")
                        CTActivityCenter.shared.authManager.saveTokenResponse(tokenResponse)
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

        CTJwtService().getJwtForActivityCenter().subscribe(onNext: { [weak self] jwtToken in
            guard let strongSelf = self else { return }

            completion(true, CTOAuth2TokenResponse(accessToken: jwtToken,
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
