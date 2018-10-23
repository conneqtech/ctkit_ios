//
//  UserService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift

public class CTUserService: NSObject {
    
    public func login(email: String, password:String) -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return CTBike.shared.authManager.login(username: email, password: password).flatMap { _ in self.fetchCurrentUser() }
    }
    
    public func create(email: String, password: String, agreedToPrivacyStatement: Bool = false) -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return CTBike.shared.authManager.getClientToken().flatMap {
            token in CTBike.shared.restManager.post(endpoint: "user",
                                                    parameters:[
                                                        "username":email,
                                                        "password":password,
                                                        "privacy_statement_accepted": agreedToPrivacyStatement
                                                    ], useToken:token)
        }
    }
    
    public func createAndLogin(email: String, password: String) -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return self.create(email: email, password: password).flatMap{ _ in self.login(email: email, password: password) }
    }

    public func patch(user: CTUserModel) -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return CTBike.shared.restManager.patch(endpoint: "user/\(user.id)", parameters: try? user.asDictionary())
    }
    
    public func fetchWith(identifier: Int) -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "user/\(identifier)")
    }
    
    public func fetchCurrentUser() -> Observable<CTResult<CTUserModel, CTBasicError>> {
        return CTBike.shared.restManager.get(endpoint: "user/me").map { (result:CTResult<CTUserModel, CTBasicError>) in
            
            switch result {
            case .success(let user):
                CTBike.shared.currentActiveUser = user
            case .failure(_):
                CTBike.shared.currentActiveUser = nil
            }
        
            return result
        }
    }
    
    public func recoverUser(email: String) -> Observable<CTResult<[String: Bool], CTBasicError>> {
        return CTBike.shared.restManager.post(endpoint: "user", parameters:["username":email])
    }
}

//MARK: - Session related functions
public extension CTUserService {
    public func hasActiveSession() -> Bool {
        return self.getActiveUserId() != -1
    }
    
    public func getActiveUserId() -> Int {
        return CTBike.shared.currentActiveUserId
    }
    
    public func logout() {
        CTBike.shared.currentActiveUser = nil
    }
}
