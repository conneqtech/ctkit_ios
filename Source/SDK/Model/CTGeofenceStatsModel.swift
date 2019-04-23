//
//  CTGeofenceStatsModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/04/2019.
//

import Foundation

public class CTGeofenceStatsModel: CTBaseModel {
    public let entriesAllTime: Int
    public let entriesInTimespan: Int

    public init() {
        entriesAllTime = 0
        entriesInTimespan = 0
    }

    enum CodingKeys: String, CodingKey {
        case entriesAllTime = "entries_all_time"
        case entriesInTimespan = "entries_in_timespan"
    }
}
