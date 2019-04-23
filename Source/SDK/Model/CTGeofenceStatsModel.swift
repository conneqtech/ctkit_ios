//
//  CTGeofenceStatsModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/04/2019.
//

import Foundation

public class CTGeofenceStatsModel: CTBaseModel {
    let entriesAllTime: Int
    let entriesInTimespan: Int

    enum CodingKeys: String, CodingKey {
        case entriesAllTime = "entries_all_time"
        case entriesInTimespan = "entries_in_timespan"
    }
}
