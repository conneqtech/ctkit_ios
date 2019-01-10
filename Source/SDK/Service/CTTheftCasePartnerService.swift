//
//  CTTheftCasePartnerService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//

import Foundation
import RxSwift

/**
 The CTTheftCasePartnerService is the main entry point to fetch the partner details for an insured or uninsired bike. The API will return the correct partner to display in the recovery process.
 */
public class CTTheftCasePartnerService: NSObject {

    /**
     Fetch the correct partner for a bike based on the insurance state
     
     - Parameter isInsured: Indicate of the bike you want a partner for is insured or not
     
     - Returns: An observable containing an array of recovery partners that are available for use in recovering the bike.
     */
    public func fetchAll(forInsuredBike isInsured: Bool) -> Observable<[CTTheftCasePartnerModel]> {
        return CTKit.shared.restManager.get(endpoint: "theft-case-partner", parameters: ["bike_is_insured":isInsured])
    }
}
