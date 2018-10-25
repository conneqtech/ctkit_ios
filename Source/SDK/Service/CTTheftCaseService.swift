//
//  CTTheftCaseService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift

public class CTTheftCaseService:NSObject {
    
    public func create(theftCase:CTTheftCaseModel) -> Observable<CTTheftCaseModel> {
        return CTBike.shared.restManager.post(endpoint: "theft-case", parameters: try? theftCase.asDictionary())
    }
    
    public func patchPoliceId(withCaseId identifier:Int, policeId:String) -> Observable<CTTheftCaseModel> {
        return CTBike.shared.restManager.patch(endpoint: "theft-case/\(identifier)", parameters: [
            "police_id":policeId])
    }
    
    public func fetch(withCaseId identifier:Int) -> Observable<CTTheftCaseModel> {
        return CTBike.shared.restManager.get(endpoint: "theft-case/\(identifier)")
    }
    
    public func fetchMostRecent(withBikeId identifier:Int) -> Observable<CTTheftCaseModel> {
        return self.fetchAll(withBikeId: identifier).map { result in
                return result[0]
        }
    }
    
    public func fetchAll(withBikeId identifier:Int) -> Observable<[CTTheftCaseModel]> {
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
