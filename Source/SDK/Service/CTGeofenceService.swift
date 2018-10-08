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
    
    public func create(withBikeId identifier: Int, name: String, latitude: Double, longitude: Double, radius: Double) -> Observable<CTGeofenceModel> {
        return CTBike.shared.restManager.post(endpoint: "bike/\(identifier)/geofence", parameters: [
            "name":name,
            "center": [
                "lat":latitude,
                "lon":longitude
            ],
            "radius":radius
            ])
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
