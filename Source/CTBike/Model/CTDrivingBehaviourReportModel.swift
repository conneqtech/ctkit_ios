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
    
    public init(
        rides: Int,
        caloriesBurned: Int,
        distance: Int,
        averagePowerDistribution: Int,
        shiftAdvice: Int,
        grouping: CTWeeklyReportGrouping
    ) {
        self.rides = rides
        self.caloriesBurned = caloriesBurned
        self.distance = distance
        self.averagePowerDistribution = averagePowerDistribution
        self.shiftAdvice = shiftAdvice
        self.grouping = grouping
    }
}

public struct CTDrivingBehaviourReportModel: CTBaseModel {
    public var groupedData: [CTDrivingBehaviourGroupedItem]
    public var totalRides: Int
    public var caloriesBurned: Int
    public var totalDistance: Int
    public var averagePowerDistribution: Int
    public var shiftAdvice: Int
    
    public init(groupedData: [CTDrivingBehaviourGroupedItem],
                totalRides: Int,
                caloriesBurned: Int,
                totalDistance: Int,
                averagePowerDistribution: Int,
                shiftAdvice: Int) {
        self.groupedData = groupedData
        self.totalRides = totalRides
        self.caloriesBurned = caloriesBurned
        self.totalDistance = totalDistance
        self.averagePowerDistribution = averagePowerDistribution
        self.shiftAdvice = shiftAdvice
    }
}
