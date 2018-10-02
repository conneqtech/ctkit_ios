//
//  UserService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift

public class CTUserService: NSObject {
    
    public func login(username: String, password:String) -> Observable<CTUserModel> {
        return CTBike.shared.authManager.login(username: username, password: password).flatMap { _ in self.fetchCurrentUser() }
    }
    
    public func create(email: String, password: String) -> Observable<CTUserModel> {
        return CTBike.shared.authManager.getClientToken().flatMap { token in CTBike.shared.restManager.post(endpoint: "user", parameters:["username":email, "password":password], useToken:token)
        }
    }

    public func patch(user: CTUserModel) -> Observable<CTUserModel> {
        return CTBike.shared.restManager.patch(endpoint: "user/\(user.id)", parameters: try? user.asDictionary())
    }
    
    public func fetchWith(identifier: Int) -> Observable<CTUserModel> {
        return CTBike.shared.restManager.get(endpoint: "user/\(identifier)")
    }
    
    public func fetchCurrentUser() -> Observable<CTUserModel> {
        return CTBike.shared.restManager.get(endpoint: "user/me").map { (user:CTUserModel) in
            CTBike.shared.currentActiveUser = user
            return user
        }
    }
    
    public func recoverUser(email: String) -> Observable<[String: Bool]> {
        return CTBike.shared.restManager.post(endpoint: "user", parameters:["username":email])
    }
    
    public func hasActiveSession() -> Bool {
        return CTBike.shared.currentActiveUserId != -1
    }
    
    public func getActiveUserId() -> Int {
        return CTBike.shared.currentActiveUserId
    }
    
    public func logout() {
        CTBike.shared.currentActiveUser = nil
    }
}
