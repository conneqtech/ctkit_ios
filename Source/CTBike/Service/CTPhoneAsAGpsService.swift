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
        do {
            let data = try JSONEncoder().encode(ridePayload)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            print("Posting RidePayload")
//            let _: Observable<CTRidePayloadModel> = CTKit.shared.restManager.post(endpoint: "/bike/\(bike.id)/ride/phone/registerloc", parameters: dictionary)
        } catch {
            print(error)
        }
    }
}
