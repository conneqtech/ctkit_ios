//
//  CTBikeTypeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//

import Foundation
import RxSwift

// Intermediate model that is used to make encoding/decoding happy.
private struct CTArticleNumberBikeTypeModel: CTBaseModel {
    var bikeTypeId: Int

    enum CodingKeys: String, CodingKey {
        case bikeTypeId = "bike_type_id"
    }
}

/**
 The CTBikeTypeService is responsible for fetching bikeType information from the api.

 This service has been added in CTKit 0.16.0
 */
public class CTBikeTypeService: NSObject {

    /**
     Fetch a bike type by its id.

     - Parameter identifier: The id of the bikeType
     - Returns: The requested bikeType
    */
    public func fetchBikeType(withId identifier: Int) -> Observable<CTBikeTypeModel> {
        return CTKit.shared.restManager.get(endpoint: "bike-type/\(identifier)")
    }

    /**
     Fetch a bike type by its articleNumber.

     - Parameter articleNumber: The articleNumber of the bike you want the bikeType for.
     - Returns: The requested bikeType
     */
    public func fetchBikeType(withArticleNumber articleNumber: String) -> Observable<CTBikeTypeModel> {
        return CTKit.shared.restManager.get(
                endpoint: "bike-type/article-number/\(articleNumber.toBase64())"
            ).flatMap { (model:CTArticleNumberBikeTypeModel) in
            return self.fetchBikeType(withId: model.bikeTypeId)
        }
    }
}
