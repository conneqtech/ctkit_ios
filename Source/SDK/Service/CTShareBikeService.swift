//
//  CTShareService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//

import Foundation
import RxSwift

public class CTShareBikeService: NSObject {

    public func fetchInviteCode(withBikeId identifier: Int) -> Observable<String?> {
        return CTBikeService().fetch(withId: identifier).map { (bike: CTBikeModel) in
            return bike.inviteUrl
        }
    }

    public func createInviteCode(withBikeId identifier: Int) -> Observable<String?> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/invite-code").map { (bike: CTBikeModel) in
            return bike.inviteUrl
        }
    }

    public func deleteInviteCode(withBikeId identifier: Int) -> Completable {
        return CTKit.shared.restManager.delete(endpoint: "bike/\(identifier)/invite-code")
    }

    public func fetchOpenLinkedUserRequests(withBikeId identifier: Int) -> Observable<CTPaginatedResponseModel<CTLinkedUserModel>> {
        return fetchLinkedUsersWithStatus(withBikeId: identifier, status: "open")
    }

    public func fetchDeniedLinkedUserRequests(withBikedId identifier: Int) -> Observable<CTPaginatedResponseModel<CTLinkedUserModel>> {
        return fetchLinkedUsersWithStatus(withBikeId: identifier, status: "denied")
    }

    public func fetchAcceptedLinkedUsers(withBikeId identifier: Int) -> Observable<CTPaginatedResponseModel<CTLinkedUserModel>> {
        return fetchLinkedUsersWithStatus(withBikeId: identifier, status: "accepted")
    }

    public func fetchRevokedLinkedUsers(withBikedId identifier: Int) -> Observable<CTPaginatedResponseModel<CTLinkedUserModel>> {
        return fetchLinkedUsersWithStatus(withBikeId: identifier, status: "revoked")
    }

    public func acceptOpenLinkedUserRequest(withBikeId bikeId: Int, linkedUserId: Int) -> Observable<CTLinkedUserModel> {
        return patchLinkedUserStatus(bikeId, linkedUserId, status: "accepted")
    }

    public func declineOpenLinkedUserRequest(withBikeId bikeId: Int, linkedUserId: Int) -> Observable<CTLinkedUserModel> {
        return patchLinkedUserStatus(bikeId, linkedUserId, status: "denied")
    }

    public func revokeAcceptedLinkedUser(withBikeId bikeId: Int, linkedUserId: Int) -> Observable<CTLinkedUserModel> {
        return patchLinkedUserStatus(bikeId, linkedUserId, status: "revoked")
    }
}

fileprivate extension CTShareBikeService {
    func fetchLinkedUsersWithStatus(withBikeId identifier: Int, status: String) -> Observable<CTPaginatedResponseModel<CTLinkedUserModel>> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/friend?invite_status=\(status)")
    }

    func patchLinkedUserStatus(_ bikeId: Int, _ linkedUserId: Int, status: String) -> Observable<CTLinkedUserModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeId)/friend/\(linkedUserId)", parameters: ["invite_status": status])
    }
}
