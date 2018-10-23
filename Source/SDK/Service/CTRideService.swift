//
//  CTRideService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

public class CTRideService:NSObject {

    public func create(withBikeId identifier: Int, startDate:Date, endDate:Date, rideType:String, name:String) -> Observable<CTResult<CTRideModel, CTBasicError>> {
        return CTBike.shared.restManager.post(endpoint: "bike/\(identifier)/ride", parameters: [
            "start_date":startDate.toAPIDate(),
            "end_date":endDate.toAPIDate(),
            "ride_type":rideType,
            "name":name
            ])
    }
    
    public func patch(ride: CTRideModel) -> Observable<CTResult<CTRideModel, CTBasicError>> {
        return CTBike.shared.restManager.patch(endpoint: "bike/ride/\(ride.id)", parameters: try? ride.asDictionary())
    }
    
    
    public func delete(withRideId identifier:Int) -> Completable {
        return CTBike.shared.restManager.archive(endpoint: "bike/ride/\(identifier)")
    }
    
    
    public func fetch(withRideId identifier: Int) -> Observable<CTResult<CTRideModel, CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "bike/ride/\(identifier)")
    }
    
    
    public func fetchAll(withBikeId identifier:Int) -> Observable<CTResult<[CTRideModel], CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)/ride")
    }
    
    
}
