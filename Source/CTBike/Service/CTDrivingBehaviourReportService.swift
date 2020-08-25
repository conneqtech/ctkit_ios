//
//  CTDrivingBehaviourReportService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation
import RxSwift

public class CTDrivingBehaviourReportService: NSObject {
    
    public func fetchBikeReport(withBikeId identifier: Int, from: Date, till: Date, grouping: CTWeeklyReportGroupingType) -> Observable<CTDrivingBehaviourReportModel> {
        return fetchReport(withBikeId: identifier, from: from, till: till, grouping: grouping)
    }
    
    public func fetchGlobalReport(from: Date, till: Date,  grouping: CTWeeklyReportGroupingType) -> Observable<CTDrivingBehaviourReportModel> {
        return fetchReport(from: from, till: till, grouping: grouping)
    }
}

// MARK: - Private API
fileprivate extension CTDrivingBehaviourReportService {
    func fetchReport(withBikeId identifier: Int? = nil, from: Date, till: Date, grouping: CTWeeklyReportGroupingType) -> Observable<CTDrivingBehaviourReportModel> {
        let parameters: [String:Any] = [
            "from": from.toAPIDate(),
            "till": till.toAPIDate(),
            "grouping_type": grouping.rawValue
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
        var totalRides = 0
        var caloriesBurned = 0
        var totalDistance = 0
        var totalShiftAdvice = 0
        var averagePowerDistribution = 0
        
        var groupedItems: [CTDrivingBehaviourGroupedItem] = []
        
        data.forEach {
            groupedItems.append(CTDrivingBehaviourGroupedItem(
                rides: $0.numRides,
                caloriesBurned: $0.caloriesBurned,
                distance: $0.distance,
                averagePowerDistribution: $0.averagePowerDistribution,
                shiftAdvice: $0.shiftAdvice,
                grouping: $0.grouping)
            )
            
            totalRides += $0.numRides
            caloriesBurned += $0.caloriesBurned
            totalDistance += $0.distance
            totalShiftAdvice += $0.shiftAdvice
            averagePowerDistribution += $0.averagePowerDistribution
        }
        
        // Average over the averages
        averagePowerDistribution /= data.count
        
        return CTDrivingBehaviourReportModel (
            groupedData: groupedItems,
            totalRides: totalRides,
            caloriesBurned: caloriesBurned,
            totalDistance: totalDistance,
            averagePowerDistribution: averagePowerDistribution,
            shiftAdvice: totalShiftAdvice
        )
    }
}
