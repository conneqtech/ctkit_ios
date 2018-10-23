//
//  CTTheftCaseService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

public class CTTheftCaseService:NSObject {
    
    public func create(theftCase:CTTheftCaseModel) -> Observable<CTResult<CTTheftCaseModel, CTBasicError>> {
        return CTBike.shared.restManager.post(endpoint: "theft-case", parameters: try? theftCase.asDictionary())
    }
    
    public func patchPoliceId(withCaseId identifier:Int, policeId:String) -> Observable<CTResult<CTTheftCaseModel, CTBasicError>> {
        return CTBike.shared.restManager.patch(endpoint: "theft-case/\(identifier)", parameters: [
            "police_id":policeId])
    }
    
    public func fetch(withCaseId identifier:Int) -> Observable<CTResult<CTTheftCaseModel, CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "theft-case/\(identifier)")
    }
    
    public func fetchMostRecent(withBikeId identifier:Int) -> Observable<CTResult<CTTheftCaseModel, CTBasicError>> {
        return self.fetchAll(withBikeId: identifier).map { result in
            switch result {
            case .success(let theftCases):
                return CTResult.success(theftCases[0])
            case .failure(let error):
                return CTResult.failure(error)
            }
        }
    }
    
    public func fetchAll(withBikeId identifier:Int) -> Observable<CTResult<[CTTheftCaseModel], CTBasicError>> {
        let params = [
            "filter": [
                "and;bike_id;eq;\(identifier)"
            ],
            "order": [
                "report_date;desc"
            ]
        ]
        return CTBike.shared.restManager.get(endpoint: "theft-case", parameters: params)
    }
    
}
