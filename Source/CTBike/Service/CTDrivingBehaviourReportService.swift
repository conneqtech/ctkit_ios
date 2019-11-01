//
//  CTDrivingBehaviourReportService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation
import RxSwift

public class CTDrivingBehaviourReportService: NSObject {

    public func fetchBikeReport(withBikeId identifier: Int, from: Date, till: Date) -> Observable<CTDrivingBehaviourReportModel> {
         return fetchReport(withBikeId: identifier, from: from, till: till)
    }

    public func fetchGlobalReport(from: Date, till: Date) -> Observable<CTDrivingBehaviourReportModel> {
        return fetchReport(from: from, till: till)
    }
}

// MARK: - Private API
fileprivate extension CTDrivingBehaviourReportService {
    func fetchReport(withBikeId identifier: Int? = nil, from: Date, till: Date) -> Observable<CTDrivingBehaviourReportModel> {
        let parameters: [String:Any] = [
           "from": from.toAPIDate(),
           "till": till.toAPIDate(),
           "tz": NSTimeZone.system.identifier
        ]

        var endpoint = "v2/bike/ride/stats"

        if let identifier = identifier {
            endpoint = "v2/bike/\(identifier)/ride/stats"
        }

        return CTKit.shared.restManager.get(endpoint: endpoint ,
           parameters: parameters).map { (response: [CTDrivingBehaviourAPIModel]) in
               return self.processReportData(data: response)
        }
    }

    func processReportData(data: [CTDrivingBehaviourAPIModel]) -> CTDrivingBehaviourReportModel {
        var morningRides = 0
        var afternoonRides = 0
        var eveningRides = 0
        var nightRides = 0

        var totalRides = 0

        var caloriesBurned = 0
        var totalDistance = 0

        data.forEach {
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
