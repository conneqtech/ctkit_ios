//
//  CTResult.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/10/2018.
//

import Foundation

public enum CTResult<Value:Codable, Error:CTErrorProtocol> {
    case success(Value)
    case failure(Error)
}
