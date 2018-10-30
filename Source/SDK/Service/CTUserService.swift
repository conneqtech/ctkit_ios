//
//  UserService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift

public class CTUserService: NSObject {
    
    /**
     Creates an authorised session for a username and password pair when the credentials are valid.
     
     - Attention: This SDK will never save the user credentials and will remove them as soon as the call finishes. The developer implementing this SDK should also *never* save the username and password in their documentation
     
     - Parameter email: The username/email used to create their account
     - Parameter password: The password the user picked when creating this account
     
     - Returns: An observable containing the logged in user. The returned CTUserModel contains all information we have on the user and can later also be retrieved by calling @see fetchCurrentUser
     */
    public func login(email: String, password:String) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.login(username: email, password: password).flatMap { _ in self.fetchCurrentUser() }
    }
    
    /**
     Create a new user for your app. This will try to register a user on the api with the given email and password. This call does not automatically create a session for your user.
     
     - Attention: This call *will not* an authorised session when creation of the account succeeds
     
     - Precondition: The password must at least be 6 characters long
     
     - Parameter email: The email address to create an account for
     - Parameter password: The password the user picked
     - Parameter agreedToPrivacyStatement: Add true to indicate the user has agreed to your privacy policy. This agreement will be saved in the API with an `agreed_on` date field.
     
     - Returns: An observable containing the created user
    */
    public func create(email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.getClientToken().flatMap {
            token in CTKit.shared.restManager.post(endpoint: "user",
                                                    parameters:[
                                                        "username":email,
                                                        "password":password,
                                                        "privacy_statement_accepted": agreedToPrivacyStatement
                                                    ], useToken:token)
        }
    }
    
    /**
     Create a new user for your app. This will try to register a user on the api with the given email and password.
     
     - Attention: This call creates an authorised session when creation of the account succeeds
     
     - Precondition: The password must at least be 6 characters long
     
     - Parameter email: The email address to create an account for
     - Parameter password: The password the user picked
     - Parameter agreedToPrivacyStatement: Add true to indicate the user has agreed to your privacy policy. This agreement will be saved in the API with an `agreed_on` date field.
     
     - Returns: An observable containing the created user
     */
    public func createAndLogin(email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return self.create(email: email, password: password, agreedToPrivacyStatement: agreedToPrivacyStatement).flatMap{ _ in self.login(email: email, password: password) }
    }

    /**
     Update user (profile) data with a `CTUserModel` The fields that will be sent to the API can be seen in the model class
     
     - Note: You are not allowed to change the email address of the user at the current time
     
     - Parameter user: A user model with updated values
     
     - Returns: An observable containing the updated user from the API. This model should be near identical to the one you used to update the user.
     */
    public func patch(user: CTUserModel) -> Observable<CTUserModel> {
        return CTKit.shared.restManager.patch(endpoint: "user/\(user.id)", parameters: try? user.asDictionary())
    }
    
    /**
     Fetch the user that the SDK currently has an active session for. This also stores the user into the CTKit shared object.
     
     - Returns: An observable containing the current logged in user.
     */
    public func fetchCurrentUser() -> Observable<CTUserModel> {
        return CTKit.shared.restManager.get(endpoint: "user/me").map { (user:CTUserModel) in
            CTKit.shared.currentActiveUser = user
            return user
        }
    }
    
    /**
     Start the recovery process for a given email address. This call always returns true on success.
     
     - Parameter email: The email address you want to start password recovery for
     
     - Returns: An observable containing success:true in a dictionary, when recovery has been attempted.
     */
    public func recoverUser(email: String) -> Observable<[String: Bool]> {
        return CTKit.shared.restManager.post(endpoint: "user", parameters:["username":email])
    }
}

//MARK: - Session related functions
public extension CTUserService {

    /**
     Utility function to determine if the SDK has an active (and autorised) session.
     
     - Returns: True if we have an active (and authorised) session
     */
    public func hasActiveSession() -> Bool {
        return self.getActiveUserId() != -1
    }
    
    /**
    Utility function that returns the current active user id.
     
     - Returns: The current active user id, -1 if there is no active session.
     */
    public func getActiveUserId() -> Int {
        return CTKit.shared.currentActiveUserId
    }
    
    /**
     Immediately end the active authorised session and reset all values in the SDK.
     */
    public func logout() {
        CTKit.shared.currentActiveUser = nil
    }
}
