//
//  CTDrivingBehaviourReportService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation
import RxSwift

public class CTDrivingBehaviourReportService: NSObject {

    public fetchReport(withBikeId identifier: Int, from: Date, till: Date) -> Observable<CTDrivingBehaviourReportModel>  {
        let parameters: [String:Any] = [
            "from": from.toAPIDate(),
            "till": till.toAPIDate(),
            "tz": NSTimeZone.system.identifier
        ]

        return CTKit.shared.restManager.get(endpoint: "v2/bike/\(identifier)/ride/stats", parameters: parameters).map { (response: [CTDrivingBehaviourAPIModel])
            return CTDrivingBehaviourReportModel(morningRides: 10,
                                                 afternoonRides: 10,
                                                 eveningRides: 10,
                                                 nightRides: 10,
                                                 caloriesBurned: 10000,
                                                 kilometersDriven: 10000
            )
        }
    }

}
