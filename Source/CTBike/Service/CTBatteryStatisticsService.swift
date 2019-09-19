//
//  CTBatteryStatsService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 06/09/2019.
//

import Foundation
import RxSwift

public class CTBatteryStatisticsService: NSObject {

    public func fetchAll(withBikeId identifier: Int,
                         from: Date,
                         till: Date) -> Observable<[CTBatteryStatisticsModel]> {
        let parameters = [
            "from": from.toAPIDate(),
            "till": till.toAPIDate()
        ]

        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/battery", parameters: parameters)
    }

    public func getCurrentBatteryState(withBikeId identifier: Int) -> Observable<CTCurrentBatteryStateModel> {
        return CTKit.shared.restManager.get("bike/\'\(identifier)/battery/current-state")
    }
}

