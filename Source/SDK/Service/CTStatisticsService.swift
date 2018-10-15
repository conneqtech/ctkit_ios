//
//  CTStatisticsService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

public class CTStatisticsService:NSObject {
    public func fetchAll(withBikeId identifier:Int) -> Observable<CTStatisticsModel> {
        return CTBike.shared.restManager.get(endpoint: "bike/\(identifier)/stats")
    }
    
}
