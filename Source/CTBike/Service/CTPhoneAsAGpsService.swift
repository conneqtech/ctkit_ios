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
    
    public func postMetaData(bike: CTBikeModel, activeTime: Int, errorMask: Int? = nil) {
        var params: [String: Any] = ["active_time": activeTime]
        if let error = errorMask {
            params["error_mask"] = error
        }
        CTKit.shared.restManager.postUnobserved(endpoint: "v2/bike/\(bike.id)/ride/phone/registermeta", parameters: params)
    }
}
