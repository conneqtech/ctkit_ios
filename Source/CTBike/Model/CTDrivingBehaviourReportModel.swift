//
//  CTDrivingBehaviourReportModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//

import Foundation

public struct CTDrivingBehaviourReportModel: CTBaseModel {

    public var morningRides: Int
    public var afternoonRides: Int
    public var eveningRides: Int
    public var nightRides: Int
    public var totalRides: Int

    public var caloriesBurned: Int
    public var totalDistance: Int
}
