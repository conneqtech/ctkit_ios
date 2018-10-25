//
//  CTLocationHistoryService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/10/2018.
//

import Foundation
import RxSwift

public class CTBikeLocationService: NSObject {
    public func fetchHistoryForBike(withId identifier: Int, from: Date, until: Date) -> Observable<[CTBikeLocationModel]> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)/location", parameters: [
            "from":from.toAPIDate(),
            "till":until.toAPIDate()
        ])
    }
    
    public func fetchLastLocationOfBike(withId identifier: Int) -> Observable<CTBikeLocationModel>? {
        return CTBikeService().fetch(withId: identifier).map { (bike:CTBikeModel) in return bike.lastLocation!}
    }
}
