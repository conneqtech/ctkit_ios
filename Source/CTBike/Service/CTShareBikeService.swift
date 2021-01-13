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

    public func fetchOpenInvites(withBikeId identifier: Int) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBikeId: identifier, status: "open")
    }

    public func fetchDeniedInvites(withBikedId identifier: Int) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBikeId: identifier, status: "denied")
    }

    public func fetchAcceptedInvites(withBikeId identifier: Int) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBikeId: identifier, status: "accepted")
    }

    public func fetchRevokedInvites(withBikedId identifier: Int) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        return fetchInvites(withBikeId: identifier, status: "revoked")
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
    
    public func fetchSingleInvite(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(bikeId)/invite/\(inviteId)")
    }
}

fileprivate extension CTShareBikeService {

    func fetchInvites(withBikeId identifier: Int, status: String) -> Observable<CTPaginatedResponseModel<CTInviteModel>> {
        
        var optionalBike: CTBikeModel? = nil
        let semaphore = DispatchSemaphore(value: 0)
        CTBikeService().fetch(withId: identifier).map {bike in
            optionalBike = bike
            semaphore.signal()
        }
        semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 1000000000))
        
        if let bike = optionalBike, bike.isRequestingUserOwner {
            return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/invite?filter=or;invite_status;eq;\(status)")
        } else {
            let mockCTMeta = CTMeta(limit: 0, offset: 0, totalRecords: 0, availableFilterFieldNames: [], availableOrderFieldNames: [])
            let mockPaginatedResponseModel: CTPaginatedResponseModel<CTInviteModel> = CTPaginatedResponseModel(filters: [], orderClauses: [], meta: mockCTMeta, data: [])
            return Observable.of(mockPaginatedResponseModel)
        }
    }

    func patchInviteStatus(_ bikeId: Int, _ inviteId: String, status: String) -> Observable<CTInviteModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeId)/invite/\(inviteId)", parameters: ["invite_status": status])
    }
}
