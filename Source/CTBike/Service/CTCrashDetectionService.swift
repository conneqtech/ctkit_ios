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
        return fetchEmergencyContact(withBikeId: bikeId).flatMap { response -> Observable<CTInviteModel> in
            guard let response = response else { // We didn't have an emergency contact yet.
                return self.setEmergencyContactStatus(withBikeId: bikeId, inviteId: inviteId, enabled: true)
            }

            return self.removeEmergencyContact(withBikeId: bikeId, inviteId: response.id).flatMap { _ in
                return self.setEmergencyContactStatus(withBikeId: bikeId, inviteId: inviteId, enabled: true)
            }
        }
    }

    public func removeEmergencyContact(withBikeId bikeId: Int, inviteId: String) -> Observable<CTInviteModel> {
        return setEmergencyContactStatus(withBikeId: bikeId, inviteId: inviteId, enabled: false)
    }

    public func fetchEmergencyContact(withBikeId bikeId: Int) -> Observable<CTInviteModel?> {
        return CTShareBikeService().fetchAcceptedInvites(withBikeId: bikeId).map { (response: CTPaginatedResponseModel<CTInviteModel>) in
            return response.data.filter { $0.isEmergencyContact == true }.first
        }
    }
}

fileprivate extension CTCrashDetectionService {
    func setEmergencyContactStatus(withBikeId bikeId: Int, inviteId: String, enabled: Bool)  -> Observable<CTInviteModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bikeId)/invite/\(inviteId)", parameters: ["is_emergency_contact": enabled])
    }
}
