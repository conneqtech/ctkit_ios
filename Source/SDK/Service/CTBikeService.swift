//
//  CTBikeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public class CTBikeService: NSObject {
    
    public func create(withName name: String, imei: String, frameNumber: String) -> Observable<CTResult<CTBikeModel, CTBasicError>> {
        return CTBike.shared.restManager.post(endpoint: "bike", parameters: [
            "name":name,
            "imei":imei,
            "frame_number":frameNumber]
        )
    }
    
    
    public func patch(withBike bike: CTBikeModel) -> Observable<CTResult<CTBikeModel, CTBasicError>> {
        return CTBike.shared.restManager.patch(endpoint: "bike", parameters: try? bike.asDictionary())
    }
    
    public func delete(withBikeId identifier: Int) -> Completable {
        return CTBike.shared.restManager.archive(endpoint: "bike/\(identifier)")
    }
    
    public func fetch(withId identifier: Int) -> Observable<CTResult<CTBikeModel, CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)")
    }
    
    public func fetchAll() -> Observable<CTResult<[CTBikeModel], CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "bike")
    }
    
    public func fetchOwned() -> Observable<CTResult<[CTBikeModel], CTBasicError>> {
        return self.fetchAll().map { result in
            switch result {
            case .success(let bikes):
                let filtered = bikes.filter{ $0.owner.id == CTBike.shared.currentActiveUserId }
                return CTResult.success(filtered)
            case .failure(let error):
                return CTResult.failure(error)
            }
        }
    }
    
    public func fetchShared() -> Observable<CTResult<[CTBikeModel], CTBasicError>> {
        return self.fetchAll().map { result in
            switch result {
            case .success(let bikes):
                let filtered = bikes.filter{ $0.owner.id != CTBike.shared.currentActiveUserId }
                return CTResult.success(filtered)
            case .failure(let error):
                return CTResult.failure(error)
            }
        }
    }
}
