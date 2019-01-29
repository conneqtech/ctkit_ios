//
//  DateFormatter+CTKit.swift
//  ctkit
//
//  Created by Jens Walrave on 29/01/2019.
//

import Foundation


internal extension DateFormatter {
    static let iso8601CT: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
