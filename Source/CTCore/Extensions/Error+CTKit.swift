//
//  Error+CTKit.swift
//  Conneqtech
//
//  Created by Inigo Llamosas on 14/06/2021.
//  Copyright © 2021 Conneqtech. All rights reserved.
//

import Foundation
import Alamofire

extension Error {
    
    func getInfoFromResponse(_ response: DataResponse<Any>) -> [String: Any] {
        
        var responseInfo = [String: Any]()
        responseInfo["localizedDescription"] = self.localizedDescription

        if let innerResponse = response.response{
            responseInfo["statusCode"] = innerResponse.statusCode
            responseInfo["description"] = innerResponse.description
        }
        
        if let data = response.data {
            let json = String(data: data, encoding: .utf8)
            responseInfo["data"] = json
        }

        responseInfo["error"] = response.result.error
        responseInfo["description"] = response.result.description

        return responseInfo
    }
}
