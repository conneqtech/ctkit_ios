//
//  Date.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation

internal extension Date {
    static func today() -> Date {
        let date = Date()
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }

    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    func toAPIDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
}
