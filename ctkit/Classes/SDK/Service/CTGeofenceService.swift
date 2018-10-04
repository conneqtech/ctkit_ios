//
//  CTGeofenceService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation
import RxSwift

public class CTGeofenceService: NSObject {
    
    public func fetch(withGeofenceId identifier: Int) -> Observable<CTGeofenceModel> {
        return CTBike.shared.restManager.get(endpoint: "bike/geofence/\(identifier)")
    }
    
    public func patch(geofence: CTGeofenceModel) -> Observable<CTGeofenceModel> {
        return CTBike.shared.restManager.patch(endpoint: "bike/geofence/\(geofence.id)", parameters: try? geofence.asDictionary())
    }
    
    public func delete(withGeofenceId identifier: Int) -> Completable {
        return CTBike.shared.restManager.archive(endpoint: "bike/geofence/\(identifier)")
    }
    
    public func fetchAll(withBikeId identifier: Int) -> Observable<[CTGeofenceModel]> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)/geofence")
    }
}
