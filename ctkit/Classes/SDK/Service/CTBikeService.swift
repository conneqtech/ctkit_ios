//
//  CTBikeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public class CTBikeService: NSObject {
    
    public func create(withName name: String, imei: String, frameNumber: String) -> Observable<CTBikeModel> {
        return CTBike.shared.restManager.post(endpoint: "bike", parameters: [
            "name":name,
            "imei":imei,
            "frame_number":frameNumber]
        )
    }
    
    
    public func patch(withBike bike: CTBikeModel) -> Observable<CTBikeModel> {
        return CTBike.shared.restManager.patch(endpoint: "bike", parameters: try? bike.asDictionary())
    }
    
    public func delete(withBikeId: Int) -> Observable<CTBikeModel> {
         return Observable.empty()
        //TODO: Implement this function
        //TODO: Find out how to handle the empty success response of a delete call
    }
    
    public func fetch(withId identifier: Int) -> Observable<CTBikeModel> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)")
    }
    
    public func fetchAll() -> Observable<[CTBikeModel]> {
        return CTBike.shared.restManager.get(endpoint: "bike")
    }
    
    public func fetchOwned() -> Observable<[CTBikeModel]> {
        return self.fetchAll().map { $0.filter{ $0.owner.id == CTBike.shared.currentActiveUserId }}
    }
    
    public func fetchShared() -> Observable<[CTBikeModel]> {
         return self.fetchAll().map { $0.filter{ $0.owner.id != CTBike.shared.currentActiveUserId }}
    }
}
