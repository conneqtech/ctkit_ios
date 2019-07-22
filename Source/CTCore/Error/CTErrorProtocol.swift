//
//  CTErrorProtocol.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//

import Foundation

public protocol CTErrorProtocol: LocalizedError {
    var code: Int { get }
    var translationKey: String { get }
    var errorBody: [String: Any] { get }

    var description: String { get }
    var type: CTErrorType { get }
}
