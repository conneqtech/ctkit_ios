//
//  CTShareService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//

import Foundation
import RxSwift


public class CTShareBikeService: NSObject {

    public func fetchInviteCode(forBike identifier: Int) -> Observable<String?> {
        return CTBikeService().fetch(withId: identifier).map { (bike: CTBikeModel) in
            return bike.inviteCode
        }
    }

    public func createInviteCode(forBike identifier: Int) -> Observable<String?> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/invite-code").map { (bike: CTBikeModel) in
            return bike.inviteCode
        }
    }

    public func deleteInviteCode(forBike identifier: Int) -> Completable {
        return CTKit.shared.restManager.delete(endpoint: "bike/\(identifier)/invite-code")
    }


    public func fetchLinkedUsers(forBike identifier: Int) -> Observable<[CTLinkedUserModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/friend")
    }
    

    public func acceptLinkedUser(withIdentifier identifier: Int) -> Observable<CTLinkedUserModel> {
        return Observable.empty()
    }

    /* Discussion: Maybe we don't need this if a pending user can be 'deleted'? */
    public func declineLinkedUser(withIdentifier identifier: Int) -> Completable {
        return Completable.empty()
    }

    public func deleteLinkedUser(withIdentiier identifier: Int) -> Completable {
        return Completable.empty()
    }
}
