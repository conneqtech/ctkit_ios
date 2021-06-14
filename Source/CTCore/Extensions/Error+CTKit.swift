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
    
    func getDescriptiveErrorFromResponse(response: DataResponse<Any>) -> String {
        
        var error = "localizedDescription: \(self.localizedDescription)"

        if let statusCode = response.response?.statusCode{
            error += " statusCode: \(statusCode)"
        }
        
        if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
            error += " data: \(json)"
            print("Failure Response: \(json)")
        }
        
        return error
    }
}
