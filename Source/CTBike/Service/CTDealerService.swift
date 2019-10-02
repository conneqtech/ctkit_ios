//
//  CTDealerService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 20/09/2019.
//

import Foundation
import RxSwift

public class CTDealerService: NSObject {

    public func fetchAllPaginated(withPage page: Int = 1, limit: Int = 50) -> Observable<CTPaginatedResponseModel<CTDealerModel>> {
        let parameters: [String:Any] = [
            "limit": limit,
            "offset": (page - 1) * limit
        ]

        return CTKit.shared.restManager.get(endpoint: "dealer", parameters: parameters)
    }

    public func searchPaginated(withSearchTerm search: String, page: Int = 1, limit: Int = 50) -> Observable<CTPaginatedResponseModel<CTDealerModel>> {
        let parameters: [String:Any] = [
            "filter": [
                "or;name;like;\(search)",
                "or;reference;like;\(search)",
                "or;address;like;\(search)",
                "or;city;like;\(search)",
                "or;postal_code;like;\(search)"
            ],
            "limit": limit,
            "offset": (page - 1) * limit
        ]

        return CTKit.shared.restManager.get(endpoint: "dealer", parameters: parameters)
    }

    public func fetchDealer(withId identfier: Int) -> Observable<CTDealerModel> {
        return CTKit.shared.restManager.get(endpoint: "dealer/\(identfier)")
    }


    public func linkDealer(withId dealerIdentifier: Int, toBike bikeIdentifier: Int) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeIdentifier)", parameters: [
            "dealer_id" : dealerIdentifier
        ])
    }

    public func unlinkDealer(fromBike identifier: Int) -> Observable<CTBikeModel> {
         return CTKit.shared.restManager.patch(endpoint: "bike/\(identifier)", parameters: [
            "dealer_id" : 0
       ])
    }
}
