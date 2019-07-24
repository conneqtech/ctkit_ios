//
//  CTGeofenceStatsModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/04/2019.
//

import Foundation

public struct CTGeofenceStatsModel: CTBaseModel {
    public var geofenceId: Int
    public let entriesAllTime: Int
    public let entriesInTimespan: Int

    enum CodingKeys: String, CodingKey {
        case geofenceId
        case entriesAllTime = "entries_all_time"
        case entriesInTimespan = "entries_in_timespan"
    }

    public init() {
        entriesInTimespan = -1
        entriesAllTime = -1
        geofenceId = -1
    }

   public init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        entriesAllTime = try values.decode(Int.self, forKey: .entriesAllTime)
        entriesInTimespan = try values.decode(Int.self, forKey: .entriesInTimespan)
        geofenceId = -1
    }
}
