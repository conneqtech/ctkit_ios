//
//  CTRequestAdapter.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 27/09/2018.
//

import Foundation
import Alamofire

class CTRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
            let accessToken = CTKit.shared.authManager.getActiveSessionToken()
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            return urlRequest
        }

        return urlRequest
    }
}
