//
//  CTBikeTypeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//

import Foundation
import RxSwift

private struct ArticleNumberBikeTypeModel: CTBaseModel {
    var bikeTypeId: Int

    enum CodingKeys: String, CodingKey {
        case bikeTypeId = "bike_type_id"
    }
}

public class CTBikeTypeService: NSObject {

    public func getBikeType(withId identifier: Int) -> Observable<CTBikeTypeModel> {
        return CTKit.shared.restManager.get(endpoint: "bike-type/\(identifier)")
    }

    public func getBikeType(withArticleNumber articleNumber: String) -> Observable<CTBikeTypeModel> {
        return CTKit.shared.restManager.get(
                endpoint: "bike-type/article-number/\(articleNumber.toBase64())"
            ).flatMap { (model:ArticleNumberBikeTypeModel) in
            return self.getBikeType(withId: model.bikeTypeId)
        }
    }
}
