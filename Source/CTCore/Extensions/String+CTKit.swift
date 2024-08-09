//
//  String+CTKit.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//

import UIKit

extension String {

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func fromAPIDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
