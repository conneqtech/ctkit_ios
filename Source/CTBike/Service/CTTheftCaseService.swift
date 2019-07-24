//
//  CTTheftCaseService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

/**
 The CTTheftCaseService is the main entry point to create, fetch and patch policeIds for theft-cases. Theft-cases are created for stolen bikes and are used as help for recovery.
 Theft-cases allow users to report their bikes as stolen and start the recovery process.
 */
public class CTTheftCaseService: NSObject {

    /**
     Create a theftcase or a certain bike.
     
     - Parameter theftCase: A theft case dictionary holding all details for the report.
     
     - Returns: An observable containing the created theft-case.
     */
    public func create(theftCase: CTTheftCaseModel) -> Observable<CTTheftCaseModel> {
        return CTKit.shared.restManager.post(endpoint: "theft-case", parameters: try? theftCase.asDictionary())
    }

    /**
     Patch a policeId for an existing theft-case.
     
     - Parameter policeId: A string containing the policeId.
     
     - Returns: An observable containing theft-case with the patched policeId.
     */
    public func patchPoliceId(withCaseId identifier: Int, policeId: String) -> Observable<CTTheftCaseModel> {
        return CTKit.shared.restManager.patch(endpoint: "theft-case/\(identifier)", parameters: [
            "police_case_number": policeId])
    }

    /**
     Fetch an existing theft-case.
     
     - Parameter caseId: The id of the theft-case.
     
     - Returns: An observable containing the fetched theft-case.
     */
    public func fetch(withCaseId identifier: Int) -> Observable<CTTheftCaseModel> {
        return CTKit.shared.restManager.get(endpoint: "theft-case/\(identifier)")
    }

    /**
     Fetch the most recent theft-case for a bike.
     
     - Parameter bikeId: The bikeId in the theft-case
     
     - Returns: An observable containing the most recent theft-case.
     */
    public func fetchMostRecent(withBikeId identifier: Int) -> Observable<CTTheftCaseModel> {
        return self.fetchAll(withBikeId: identifier).map { result in
                return result.data[0]
        }
    }

    /**
     Fetch all theft-cases for a bike.
     
     - Parameter bikeId: The id of the bike.
     
     - Returns: An observable array containing all theft-cases for a bike.
     */
    public func fetchAll(withBikeId identifier: Int, finalized: Bool = false) -> Observable<CTPaginatedResponseModel<CTTheftCaseModel>> {
        let params = [
            "filter": [
                "and;bike_id;eq;\(identifier)",
                "and;finalized;eq;\(finalized)"
            ],
            "order": [
                "report_date;desc"
            ]
        ]
        return CTKit.shared.restManager.get(endpoint: "theft-case", parameters: params)
    }
}
