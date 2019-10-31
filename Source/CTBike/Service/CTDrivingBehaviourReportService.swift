//
//  CTDrivingBehaviourReportService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation
import RxSwift

public class CTDrivingBehaviourReportService: NSObject {

    public func fetchReport(withBikeId identifier: Int, from: Date, till: Date, global: Bool = false) -> Observable<CTDrivingBehaviourReportModel> {
        let parameters: [String:Any] = [
            "global": global,
            "from": from.toAPIDate(),
            "till": till.toAPIDate(),
            "tz": NSTimeZone.system.identifier
        ]

        return CTKit.shared.restManager.get(endpoint: "v2/bike/\(identifier)/ride/stats",
            parameters: parameters).map { (response: [CTDrivingBehaviourAPIModel]) in

            var morningRides = 0
            var afternoonRides = 0
            var eveningRides = 0
            var nightRides = 0

            var totalRides = 0

            var caloriesBurned = 0
            var totalDistance = 0

            response.forEach {
                switch $0.timeOfDay {
                case .morning:
                    morningRides = $0.numRides
                case .afternoon:
                    afternoonRides = $0.numRides
                case .evening:
                    eveningRides = $0.numRides
                case .night:
                    nightRides = $0.numRides
                }

                totalRides += $0.numRides
                caloriesBurned += $0.caloriesBurned
                totalDistance += $0.distance
            }

            return CTDrivingBehaviourReportModel(morningRides: morningRides,
                                                 afternoonRides: afternoonRides,
                                                 eveningRides: eveningRides,
                                                 nightRides: nightRides,
                                                 totalRides: totalRides,
                                                 caloriesBurned: caloriesBurned,
                                                 totalDistance: totalDistance
            )
        }
    }

}
