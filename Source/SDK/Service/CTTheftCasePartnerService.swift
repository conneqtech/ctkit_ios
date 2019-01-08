//
//  CTTheftCasePartnerService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//

import Foundation
import RxSwift

public class CTTheftCasePartnerService: NSObject {
    
    public func fetchAll(forInsuredBike isInsured: Bool) -> Observable<[CTTheftCasePartnerModel]> {
        return CTKit.shared.restManager.get(endpoint: "theft-case-partner", parameters: ["bike_is_insured":isInsured])
    }
    
}
