//
//  CTLocationHistoryService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/10/2018.
//

import Foundation
import RxSwift

public class CTBikeLocationService: NSObject {
    public func getHistoryForBike(withId identifier: Int, from: Date, until: Date) -> Observable<[CTBikeLocationModel]> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)/location", parameters: [
            "from":from.toAPIDate(),
            "till":until.toAPIDate()
        ])
    }
}

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
