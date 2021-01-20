//
//  CTShareService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//

import Foundation
import RxSwift

public class CTShareBikeService: NSObject {

    public func fetchInviteUri(withBikeId identifier: Int) -> Observable<String?> {
        return CTBikeService().fetch(withId: identifier).map { (bike: CTBikeModel) in
            return bike.inviteUri
        }
    }

    public func createInviteUri(withBikeId identifier: Int) -> Observable<String?> {
        return CTKit.shared.restManager.post(endpoint: "bike/\(identifier)/invite-code").map { (bike: CTBikeModel) in
            return bike.inviteUri
        }
    }

    public func deleteInviteUri(withBikeId identifier: Int) -> Completable {
        return CTKit.shared.restManager.delete(endpoint: "bike/\(identifier)/invite-code")
    }

    public func fetchOpenInvites(withBike bike: CTBikeModel) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBike: bike, status: "open")
    }

    public func fetchDeniedInvites(withBike bike: CTBikeModel) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBike: bike, status: "denied")
    }

    public func fetchAcceptedInvites(withBike bike: CTBikeModel) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBike: bike, status: "accepted")
    }

    public func fetchRevokedInvites(withBike bike: CTBikeModel) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBike: bike, status: "revoked")
    }

    public func acceptOpenInvite(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return patchInviteStatus(bikeId, inviteId, status: "accepted")
    }

    public func declineOpenInvite(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return patchInviteStatus(bikeId, inviteId, status: "denied")
    }

    public func revokeAcceptedInvite(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return patchInviteStatus(bikeId, inviteId, status: "revoked")
    }
    
    public func fetchSingleInvite(withBike bike: CTBikeModel, inviteId: String) -> Observable<CTInviteModel> {
        if !bike.isRequestingUserOwner {
            return CTInviteModel.mockInvite()
        } else {
            return CTKit.shared.restManager.get(endpoint: "bike/\(bike.id)/invite/\(inviteId)")
        }
    }
    
    func fetchInvites(withBike bike: CTBikeModel, status: String) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        if bike.isRequestingUserOwner {
            return CTKit.shared.restManager.get(endpoint: "bike/\(bike.id)/invite?filter=or;invite_status;eq;\(status)")
        } else {
            return CTInviteModel.mockPaginatedInvite()
        }
    }
}

fileprivate extension CTShareBikeService {

    func patchInviteStatus(_ bikeId: Int, _ inviteId: String, status: String) -> Observable<CTInviteModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeId)/invite/\(inviteId)", parameters: ["invite_status": status])
    }
}
