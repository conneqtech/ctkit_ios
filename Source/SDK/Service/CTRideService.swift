//
//  CTRideService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

/**
 The CTRideService is the main entry point to create and fetch rides for a bike.
 Rides are created by users and are part of the bike location history.
 Bike rides allow the user to keep track of their movements without continuously searching through the history
 */
public class CTRideService: NSObject {

    /**
     Create a new ride for a bike.
     
     - Parameter identifier: The bike id you want to create the ride for
     - Parameter startDate: A date with time indicating the startpoint of the ride
     - Parameter endDate: A date with time indicating the endpoint of the ride
     - Parameter rideType: A type to mark the type of a ride
     - Parameter name: The name for the ride, this is chosen by the user
     
     - Returns: An observable with the created ride.
     */
    public func create(withBikeId identifier: Int, startDate: Date, endDate: Date, rideType: String, name: String) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/ride", parameters: [
            "start_date": startDate.toAPIDate(),
            "end_date": endDate.toAPIDate(),
            "ride_type": rideType,
            "name": name
            ])
    }

    /**
     Update the ride with the ride model.
     
     - Parameter ride: The ride you want to update with new data
     
     - Returns: An observable with the updated ride.
     */
    public func patch(ride: CTRideModel) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/ride/\(ride.id)", parameters: try? ride.asDictionary())
    }

    /**
     Delete the ride with the ride identifier
     
     - Parameter identifier: The ride id you want to delete
     
     - Returns: A completable to indicate the deletion was successful.
    */
    public func delete(withRideId identifier: Int) -> Observable<Int> {
        return CTKit.shared.restManager.archive(endpoint: "bike/ride/\(identifier)").map { (_: CTRideModel) in identifier }
    }

    /**
     Fetch a single ride with its identifier
     
     - Parameter identifier: The id of the ride you want to fetch
     
     - Returns: An observable containing a single ride
     */
    public func fetch(withRideId identifier: Int) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/ride/\(identifier)")
    }

    /**
     Fetch a list of rides for a bike, using the identifier of the bike
     
     - Parameter identifier: The identifier of the bike you want to fetch the list of rides for
     
     - Returns: An observable containing an array of rides
     */
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTRideModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/ride")
    }

    public func fetchAllPaginated(withBikeId identifier: Int, page: Int = 1, limit: Int = 50) -> Observable<CTPaginatedResponseModel<CTRideModel>> {
        let parameters: [String:Any] = [
            "order": [
                "start_date;desc"
            ],
            "limit": limit,
            "offset": (page - 1) * limit
        ]

        return CTKit.shared.restManager.get(endpoint: "v2/bike/\(identifier)/ride", parameters: parameters)
    }

    public func getTranslationKey(forRide ride: CTRideModel) -> String {
        return "ride.name.\(getDayName(forDate: ride.startDate)).\(getDayPartName(forDate: ride.startDate))"
    }
}

//MARK: Internal functions for ride names
internal extension CTRideService {

    func getDayName(forDate date: Date) -> String {
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let weekDayNames = [
            "sunday",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday"
        ]

        return weekDayNames[dayOfWeek - 1]
    }

    func getDayPartName(forDate date: Date) -> String {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())

        let rideHour = calendar.component(.hour, from: date)
        let rideMinutes = calendar.component(.minute, from: date)
        let rideSeconds = calendar.component(.second, from: date)

        let normalizedDate = calendar.date(byAdding: DateComponents(calendar: calendar,
                                                                    hour: rideHour,
                                                                    minute: rideMinutes,
                                                                    second: rideSeconds),
                                           to: startOfToday)!

        // 00:00 -> 06:00 = night
        let nightBeginDate = calendar.date(byAdding: DateComponents(calendar: calendar, hour: 0), to: startOfToday)!
        let nightEndDate = calendar.date(byAdding: DateComponents(calendar: calendar, hour: 6), to: startOfToday)!

        // 06:01 -> 11:59:59 = morning
        let morningBeginDate = calendar.date(byAdding: DateComponents(calendar: calendar, hour: 6, minute: 0, second: 1), to: startOfToday)!
        let morningEndDate = calendar.date(byAdding: DateComponents(calendar: calendar,
                                                                    hour: 11,
                                                                    minute: 59,
                                                                    second: 59), to: startOfToday)!

        // 12:01 -> 17:59:59 = afternoon
        let afternoonBeginDate = calendar.date(byAdding: DateComponents(calendar: calendar, hour: 12, minute: 0, second: 0), to: startOfToday)!
        let afternoonEndDate = calendar.date(byAdding: DateComponents(calendar: calendar,
                                                                      hour: 17,
                                                                      minute: 59,
                                                                      second: 59), to: startOfToday)!

        // 18:01 -> 23:59 = evening
        let eveningBeginDate = calendar.date(byAdding: DateComponents(calendar: calendar, hour: 18), to: startOfToday)!
        let eveningEndDate = calendar.date(byAdding: DateComponents(calendar: calendar,
                                                                    hour: 23,
                                                                    minute: 59,
                                                                    second: 59), to: startOfToday)!

        if normalizedDate >= nightBeginDate, normalizedDate <= nightEndDate {
            return "night"
        }

        if normalizedDate >= morningBeginDate, normalizedDate <= morningEndDate {
            return "morning"
        }

        if normalizedDate >= afternoonBeginDate, normalizedDate <= afternoonEndDate {
            return "afternoon"
        }

        if normalizedDate >= eveningBeginDate, normalizedDate <= eveningEndDate {
            return "evening"
        }

        return "day"
    }

}
