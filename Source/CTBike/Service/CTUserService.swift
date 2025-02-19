//
//  UserService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift

/**
 The CTUserService can be used to create new users for the Conneqtech connected bike platform. This service has some convenience methods like `createAndLogin` to automatically create a session once the user has been created.
 
 This service is the main entry point for user based interactions, including checking for an active session, getting the active user identifier and logging out (and thus destroying the session).
 */
public class CTUserService: NSObject {

    /**
     Creates an authorised session for a username and password pair when the credentials are valid.
     
     - Attention: This SDK will never save the user credentials and will remove them as soon as the call finishes. The developer implementing this SDK should also *never* save the username and password in their documentation
     
     - Parameter email: The username/email used to create their account
     - Parameter password: The password the user picked when creating this account
     
     - Returns: An observable containing the logged in user. The returned CTUserModel contains all information we have on the user and can later also be retrieved by calling @see fetchCurrentUser
     */
    public func login(email: String, password: String) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.login(username: email, password: password).flatMap { _ in self.fetchCurrentUser() }
    }

    /**
     Creates an authorised session for a social login swhen the credentials are valid.
     
     - Attention: This SDK will never save the user credentials and will remove them as soon as the call finishes. The developer implementing this SDK should also *never* save the username and password in their documentation
     
     - Parameter token: The token retrieved from the social network
     - Parameter type: The type of social network used, this can be google or facebook
     
     - Returns: An observable containing the logged in user. The returned CTUserModel contains all information we have on the user and can later also be retrieved by calling @see fetchCurrentUser
     */
    public func login(socialToken token: String, type: String) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.login(token: token, type: type).flatMap { _ in self.fetchCurrentUser() }
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
    public func create(withEmail email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.getClientToken().flatMap {
            token in CTKit.shared.restManager.post(endpoint: "user",
                                                    parameters: [
                                                        "username": email,
                                                        "password": password,
                                                        "privacy_statement_accepted": agreedToPrivacyStatement
                                                    ], useToken: token)
        }
    }

    /**
     Create a new user for your app. This will try to register a user on the api with the given email and password. This call does not automatically create a session for your user.
     
     - Attention: This call *will not* an authorised session when creation of the account succeeds
     
     - Precondition: The password must at least be 6 characters long
     
     - Parameter name: The name of the user
     - Parameter email: The email address to create an account for
     - Parameter password: The password the user picked
     - Parameter agreedToPrivacyStatement: Add true to indicate the user has agreed to your privacy policy. This agreement will be saved in the API with an `agreed_on` date field.
     
     - Returns: An observable containing the created user
     */
    public func create(withName name: String, email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return CTKit.shared.authManager.getClientToken().flatMap {
            token in CTKit.shared.restManager.post(endpoint: "user",
                                                   parameters: [
                                                    "name": name,
                                                    "username": email,
                                                    "password": password,
                                                    "privacy_statement_accepted": agreedToPrivacyStatement
                ], useToken: token)
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
    public func createAndLogin(withEmail email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return self.create(withEmail: email, password: password, agreedToPrivacyStatement: agreedToPrivacyStatement).flatMap { _ in self.login(email: email, password: password) }
    }

    /**
     Create a new user for your app. This will try to register a user on the api with the given email and password.
     
     - Attention: This call creates an authorised session when creation of the account succeeds
     
     - Precondition: The password must at least be 6 characters long
     
     - Parameter name: The name of the user
     - Parameter email: The email address to create an account for
     - Parameter password: The password the user picked
     - Parameter agreedToPrivacyStatement: Add true to indicate the user has agreed to your privacy policy. This agreement will be saved in the API with an `agreed_on` date field.
     
     - Returns: An observable containing the created user
     */
    public func createAndLogin(withName name: String, email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTUserModel> {
        return self.create(withName: name, email: email, password: password, agreedToPrivacyStatement: agreedToPrivacyStatement).flatMap { _ in self.login(email: email, password: password) }
    }

    /**
     Update user (profile) data with a `CTUserModel` The fields that will be sent to the API can be seen in the model class
     
     - Note: You are not allowed to change the email address of the user at the current time
     
     - Parameter user: A user model with updated values
     
     - Returns: An observable containing the updated user from the API. This model should be near identical to the one you used to update the user.
     */
    public func patchCurrentUser(user: CTUserModel) -> Observable<CTUserModel> {
        return CTKit.shared.restManager.patch(endpoint: "user/me", parameters: try? user.asDictionary())
    }

    public func patchCurrentUserSpecificParamsOnly(parameters: [String: Any]) -> Observable<CTUserModel> {
        return CTKit.shared.restManager.patch(endpoint: "user/me", parameters: parameters)
    }
    
    /**
     Fetch the user that the SDK currently has an active session for. This also stores the user into the CTKit shared object.
     
     - Returns: An observable containing the current logged in user.
     */
    public func fetchCurrentUser() -> Observable<CTUserModel> {
        
        var endpiont = ((Int.random(in: 1..<100) % 3) == 0) ? "user/mex" : "user/me"
    
        return CTKit.shared.restManager.get(endpoint: endpoint).map { (user: CTUserModel) in
            CTKit.shared.currentActiveUser = user
            return user
        }
    }
    
    /**
     Deletes a user and by changing its status. Also affects the active subscptions.
     
     - Returns: A completable call
     */
    public func deleteAccount() -> Completable {
        return CTKit.shared.restManager.genericCompletableCall(.patch, endpoint: "user/me", parameters: ["active_state": 2], useToken: nil)
    }
    
    /**
     Check if the user account is still logged in
     
     - Returns: A completable call
     */
    public func isUserStillLoggedIn(tokenApi: String) -> Completable {
        return CTKit.shared.restManager.genericCompletableCall(.get, endpoint: "oauth/assert", parameters: nil, useToken: nil, url: tokenApi)
    }
}

// MARK: - Session related functions
public extension CTUserService {

    /**
     Utility function to determine if the SDK has an active (and autorised) session.
     
     - Returns: True if we have an active (and authorised) session
     */
    func hasActiveSession() -> Bool {
        return CTKit.shared.hasActiveSession()
    }

    /**
    Utility function that returns the current active user id.
     
     - Returns: The current active user id, -1 if there is no active session.
     */
    func getActiveUserId() -> Int {
        return CTKit.shared.currentActiveUserId
    }

    /**
     Immediately end the active authorised session and reset all values in the SDK.
     */
    func logout() {
        CTKit.shared.logout()
    }
}
