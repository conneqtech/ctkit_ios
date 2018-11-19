//
//  Encodable+CTKit.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 01/10/2018.
//

import Foundation

//As proposed by: https://stackoverflow.com/a/46329055
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
