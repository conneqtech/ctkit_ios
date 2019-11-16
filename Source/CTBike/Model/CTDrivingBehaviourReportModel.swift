//
//  CTDrivingBehaviourReportModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation

public struct CTDrivingBehaviourGroupedItem: CTBaseModel {
    public var rides: Int
    public var caloriesBurned: Int
    public var distance: Int
    public var averagePowerDistribution: Int
    public var shiftAdvice: Int
    public var grouping: CTWeeklyReportGrouping
}

public struct CTDrivingBehaviourReportModel: CTBaseModel {
    public var groupedData: [CTDrivingBehaviourGroupedItem]
    public var totalRides: Int
    public var caloriesBurned: Int
    public var totalDistance: Int
    public var averagePowerDistribution: Int
    public var shiftAdvice: Int
}
