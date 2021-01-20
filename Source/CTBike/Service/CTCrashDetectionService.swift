//
//  CTCrashDetectionService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/10/2019.
//

import Foundation
import RxSwift

public class CTCrashDetectionService: NSObject {

    public func setEmergencyContact(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
         return self.setEmergencyContactStatus(withBikeId: bikeId, inviteId: inviteId, enabled: true)
    }

    public func removeEmergencyContact(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return setEmergencyContactStatus(withBikeId: bikeId, inviteId: inviteId, enabled: false)
    }

    public func fetchEmergencyContact(withBike bike: CTBikeModel) -> Observable<CTInviteModel?> {
        return CTShareBikeService().fetchAcceptedInvites(withBike: bike).map { (response: CTPaginatedResponseModel<CTInviteModel>) in
            return response.data.filter { $0.isEmergencyContact == true }.first
        }
    }
    
   public func fetchEmergencyContacts(withBike bike: CTBikeModel) -> Observable<[CTInviteModel]> {
        return CTShareBikeService().fetchAcceptedInvites(withBike: bike).map { (response: CTPaginatedResponseModel<CTInviteModel>) in
            return response.data.filter { $0.isEmergencyContact == true }
        }
    }
}

fileprivate extension CTCrashDetectionService {
    func setEmergencyContactStatus(withBikeId bikeId: Int, inviteId: String, enabled: Bool)  -> Observable<CTInviteModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeId)/invite/\(inviteId)", parameters: ["is_emergency_contact": enabled])
    }
}
