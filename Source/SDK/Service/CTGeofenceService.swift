//
//  CTGeofenceService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation
import RxSwift

public class CTGeofenceService: NSObject {

    /**
     Fetch a single Geofence from the API with the geofence identifier.
     
     - Note: You are only able to request the geofences the user has created for their account. Requesting random other users geofences will result in a 403 error.
     
     - Parameter identifier: The ID used to reference the geofence
     
     - Returns: An observable containing the requested geofence when found
     */
    public func fetch(withGeofenceId identifier: Int) -> Observable<CTGeofenceModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/geofence/\(identifier)")
    }

    /**
     Fetch all the geofences that belong to a single bike
     
     - Note: You are only able to create a geofence for a bike that is linked to the current active user.
     Adding a geofence to a random bike will result in a 403 error
     
     - Parameter identifier: The identifier of the bike you want the geofences for
     
     - Returns: An observable with an array of Geofences, this can also be an empty array when the bike has no geofences.
     */
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTGeofenceModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/geofence")
    }

    /**
     Create a new circular geofence and add it to a bike.
     
      - Note: You are only able to create a geofence for a bike that is linked to the current active user.
     Adding a geofence to a random bike will result in a 403 error
     
     - Precondition: Radius can't be larger than 10km (10.000m)
     
     - Parameter identifier: The identifier of the bike you want to create the geofence for
     - Parameter name: The name of your geofence
     - Parameter latitude: The latitude part of the _center_ of the geofence
     - Parameter longitude: The longitude part of the _center_ of the geofence
     - Parameter radius: The radius of the geofence in meters
     
     - Returns: An observable with the newly created geofence
     */
    public func create(withBikeId identifier: Int, name: String, latitude: Double, longitude: Double, radius: Double) -> Observable<CTGeofenceModel> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/geofence", parameters: [
            "name": name,
            "center": [
                "lat": latitude,
                "lon": longitude
            ],
            "radius": radius
            ])
    }

    /**
     Adjust an existing geofence
     
     - Parameter geofence: A geofence model with the adjusted fields.
     
     - Returns: An observable with the updated geofence created from the API response
     */
    public func patch(geofence: CTGeofenceModel) -> Observable<CTGeofenceModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/geofence/\(geofence.id)", parameters: try? geofence.asDictionary())
    }

    /**
     Activate the geofence, at this point the API will resume / start sending push notifications when the user
     enters / leaves the geofence
     
     - Parameter identifier: The id of the geofence you want to activate
     - Returns:  An observable with the updated geofence created from the API response
     */
    public func activate(withGeofenceId identifier: Int) -> Observable<CTGeofenceModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/geofence/\(identifier)", parameters: [
            "active_state": 0])
    }

    /**
     Deactivate the geofence, at this point the API will *stop* sending push notifications when the user
     enters / leaves the geofence
     
     - Parameter identifier: The id of the geofence you want to deactivate
     - Returns:  An observable with the updated geofence created from the API response
     */
    public func deactivate(withGeofenceId identifier: Int) -> Observable<CTGeofenceModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/geofence/\(identifier)", parameters: [
            "active_state": 1])
    }

    /**
     Remove the geofence from the user and delete it on the API
     
     - Parameter identifier: The identifier of the geofence you want to delete
     
     - Returns: A completable that notifies you the action completed. There will be no result other than 'finished'
     */
    public func delete(withGeofenceId identifier: Int) -> Observable<Int> {
        return CTKit.shared.restManager.archive(endpoint: "bike/geofence/\(identifier)").map { (_: CTGeofenceModel) in identifier }
    }

    /**
     Get entry statistics for a single geofence.

     - Parameter identifier: The identifier of the geofence you want stats for
     - Parameter from: DateTime from which you want the timespan to start from
     - Parameter till: DateTime from which you want the timespan to end
     - Returns: An observable with stats for the given timespan
    */
    public func getStatsInTimespan(withGeofenceId identifier: Int, from: Date, till: Date) -> Observable<CTGeofenceStatsModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/geofence/\(identifier)/stats", parameters: [
            "from": from.toAPIDate(),
            "till": till.toAPIDate()
        ])
    }
}
