//
//  CTUserRecoveryService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 31/10/2018.
//

import Foundation
import RxSwift

/**
 The CTUserRecoveryService can be used to initiate a password recovery flow from within the app. This service is responsible for starting and ending the recovery process.
 */
public class CTUserRecoveryService: NSObject {

    /**
     Start the recovery process for a given email address. This call always returns true on success.
     
     - Parameter email: The email address you want to start password recovery for
     
     - Returns: An observable containing the username, when recovery has been attempted.
     */
    public func recoverUser(email: String) -> Observable<String> {
        return CTKit.shared.restManager.post(endpoint: "user/recover", parameters:["email":email]).map { (_:[String:Bool]) in email }
    }

    /**
     Finish the password recovery process with the newly chosen password and the reset hash the user received in their emailbox
     
     - Precondition: The password needs to match the same conditions as listed in the account creation calls
     
     - Parameter password: The new password to be set for the user
     - Parameter resetHash: Random hash the user received in the email.
     
     - Returns: Observable with the email the recovery was finished for.
     */
    public func finishPasswordRecovery(password: String, resetHash: String) -> Observable<String> {
        return CTKit.shared.restManager.post(endpoint: "user/recover", parameters: [
            "hash":resetHash,
            "password":password] ).map { (result:CTUserRecoveryResultModel) in result.username }
    }
}
