//
//  CTActivityCenterService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/07/2019.
//

import Foundation
import RxSwift

public class CTActivityCenterService: NSObject {

    public func fetchAllPaginated(page: Int = 1, limit: Int = 50) -> Observable<CTPaginatedResponseModel<CTActivtyModel>> {
        let parameters: [String:Any] = [
            "limit": limit,
            "offset": (page - 1) * limit
        ]

        return CTActivityCenter.shared.restManager.get(endpoint: "activity/", parameters: parameters)
    }

    public func dismissActivity(withId identifier: String) -> Completable {
        return CTActivityCenter.shared.restManager.delete(endpoint: "activity/\(identifier)/")
    }

    public func dismissAllActivities() -> Completable {
        return CTActivityCenter.shared.restManager.delete(endpoint: "activity/")
    }
}
