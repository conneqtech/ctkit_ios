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
        print(CTBike.shared.authManager.getAccesToken());
        let accessToken = CTBike.shared.authManager.getAccesToken();
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
