//
//  CTUserRecoveryService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2018.
//

import Foundation
import RxSwift

class CTUserRecoveryService: NSObject {
    
    
    /**
     Start the recovery process for a given email address. This call always returns true on success.
     
     - Parameter email: The email address you want to start password recovery for
     
     - Returns: An observable containing success:true in a dictionary, when recovery has been attempted.
     */
    public func recoverUser(email: String) -> Observable<[String: Bool]> {
        return CTKit.shared.restManager.post(endpoint: "user", parameters:["username":email])
    }
}
