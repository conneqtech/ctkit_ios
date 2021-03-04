//
//  CTPhoneAsAGpsService.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/02/2021.
//


import Foundation
import RxSwift

public class CTPhoneAsAGpsService: NSObject {

    public func postPayload(ridePayload: CTRidePayloadModel, bike: CTBikeModel) {
        return CTKit.shared.restManager.postUnobserved(endpoint: "v2/bike/\(bike.id)/ride/phone/registerloc", parameters: try? ridePayload.asDictionary())
    }
    
    public func endRide(bike: CTBikeModel) -> Observable<CTRideModel> {
        return CTKit.shared.restManager.post(endpoint: "v2/bike/\(bike.id)/ride/phone/endride")
    }
    
    public func postMetaData(bike: CTBikeModel, activeTime: Int? = nil, errorMask: Int? = nil) {
        var params: [String: Any] = [:]
        if let time = activeTime {
            params["active_time"] = time
        }
        if let error = errorMask {
            params["error_mask"] = error
        }
        CTKit.shared.restManager.postUnobserved(endpoint: "v2/bike/\(bike.id)/ride/phone/registermeta", parameters: params)
    }
    
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
