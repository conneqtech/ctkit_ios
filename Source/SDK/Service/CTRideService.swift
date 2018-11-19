//
//  CTRideService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

/**
 The CTRideService is the main entry point to create and fetch rides for a bike. Rides are created by users and are part of the bike location history.
 Bike rides allow the user to keep track of their movements without continuously searching through the history
 */
public class CTRideService:NSObject {

    /**
     Create a new ride for a bike.
     
     - Parameter identifier: The bike id you want to create the ride for
     - Parameter startDate: A date with time indicating the startpoint of the ride
     - Parameter endDate: A date with time indicating the endpoint of the ride
     - Parameter rideType: A type to mark the type of a ride
     - Parameter name: The name for the ride, this is chosen by the user
     
     - Returns: An observable with the created ride.
     */
    public func create(withBikeId identifier: Int, startDate:Date, endDate:Date, rideType:String, name:String) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/ride", parameters: [
            "start_date":startDate.toAPIDate(),
            "end_date":endDate.toAPIDate(),
            "ride_type":rideType,
            "name":name
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
    public func delete(withRideId identifier:Int) -> Completable {
        return CTKit.shared.restManager.archive(endpoint: "bike/ride/\(identifier)")
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
    public func fetchAll(withBikeId identifier:Int) -> Observable<[CTRideModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/ride")
    }
}
