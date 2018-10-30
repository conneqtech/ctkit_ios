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
        return CTKit.shared.restManager.post(endpoint: "bike", parameters: [
            "name":name,
            "imei":imei,
            "frame_number":frameNumber]
        )
    }
    
    
    public func patch(withBike bike: CTBikeModel) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike", parameters: try? bike.asDictionary())
    }
    
    public func delete(withBikeId identifier: Int) -> Completable {
        return CTKit.shared.restManager.archive(endpoint: "bike/\(identifier)")
    }
    
    public func fetch(withId identifier: Int) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)")
    }
    
    public func fetchAll() -> Observable<[CTBikeModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike")
    }
    
    public func fetchOwned() -> Observable<[CTBikeModel]> {
        return self.fetchAll().map { result in
            return result.filter{ $0.owner.id == CTKit.shared.currentActiveUserId }
        }
    }
    
    public func fetchShared() -> Observable<[CTBikeModel]> {
        return self.fetchAll().map { result in
            return result.filter{ $0.owner.id != CTKit.shared.currentActiveUserId }
        }
    }
}
