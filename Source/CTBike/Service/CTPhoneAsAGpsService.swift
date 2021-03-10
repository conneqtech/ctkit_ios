//
//  CTPhoneAsAGpsService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/02/2021.
//


import Foundation
import RxSwift

/**
 The CTPhoneAsAGpsService is the class that interacts with the API for implementing Phone as a Gpgs functionality.
 */

public class CTPhoneAsAGpsService: NSObject {

    /**
     Posts payloads for the ongoing ride. The first payload creates the ride on the API

     - Parameter ridePayload: The payload to be sent to the API

     - Parameter bike: The bike you want to create the ride for
     */
    public func postPayload(ridePayload: CTRidePayloadModel, bike: CTBikeModel, callBack: @escaping () -> ()) {
        CTKit.shared.restManager.postUnobserved(endpoint: "v2/bike/\(bike.id)/ride/phone/registerloc", parameters: try? ridePayload.asDictionary(), callBack: callBack)
    }
    
    /**
     Ends the ride

     - Parameter bike: The bike you want to end the ride for
     
     - Returns: An observable of the newly created ride object
     */
    public func endRide(bike: CTBikeModel) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.post(endpoint: "v2/bike/\(bike.id)/ride/phone/endride")
    }
    
    /**
     Posts metadata of the ongoing ride

     - Parameter bike: The bike you want to record metadata for
     - Parameter activeTime: The active time in seconds of the ongoing ride
     - Parameter errorMask: An error indicating what went wrong during the recording: 1 GPS, 2 Bluetooth, 3 GPS + Bluetooth, 4 timeout
     */
    public func postMetaData(bike: CTBikeModel, activeTime: Int? = nil, errorMask: Int? = nil) {
        var params: [String: Any] = [:]
        if let time = activeTime {
            params["active_time"] = time
        }
        if let error = errorMask {
            params["error_mask"] = error
        }
        CTKit.shared.restManager.postUnobserved(endpoint: "v2/bike/\(bike.id)/ride/phone/registermeta", parameters: params, callBack: {})
    }
    
    /**
     Updates the name and/or the rating of the ride

     - Parameter ride: The ride you want to update
     - Parameter name: The new name for the ride
     - Parameter rating: the new rating of the ride (1 to 5). It can also be unset
     
     - Returns: An observable of the updated ride object
     */
    public func patchNameRating(toRide ride: CTRideModel, name: String? = nil, rating: Int? = nil) -> Observable<CTRideModel> {
        var params: [String: Any] = [:]
        if let n = name {
            params["name"] = n
        }
        if let r = rating {
            params["rating"] = r
        }
        return CTKit.shared.restManager.patch(endpoint: "v2/bike/ride/\(ride.id)", parameters: params)
    }
}
