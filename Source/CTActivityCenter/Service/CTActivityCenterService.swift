//
//  CTActivityCenterService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/07/2019.
//

import Foundation
import RxSwift

public class CTActivityCenterService: NSObject {

    public func fetchAll() -> Observable<CTPaginatedResponseModel<CTActivtyModel>> {
        return CTActivityCenter.shared.restManager.get(endpoint: "notification/")
    }
}
