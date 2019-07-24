//
//  CTActivityCenterRequestAdapter.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import Alamofire

public class CTActivityCenterRequestAdapter: RequestAdapter {
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if urlRequest.value(forHTTPHeaderField: "Authorization") == nil {
            let accessToken = CTActivityCenter.shared.authManager.getActiveSessionToken()

            if accessToken != "" {
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }


            print("🛎")
            print(urlRequest.allHTTPHeaderFields)

            return urlRequest
        }

        return urlRequest
    }
}
