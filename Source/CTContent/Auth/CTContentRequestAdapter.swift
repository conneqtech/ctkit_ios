//
//  CTContentApiRequestAdapter.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/09/2019.
//

import Foundation
import Alamofire

public class CTContentRequestAdapter: RequestAdapter {
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
            let accessToken = CTContent.shared.authManager.getActiveSessionToken()
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            return urlRequest
        }

        return urlRequest
    }
}
