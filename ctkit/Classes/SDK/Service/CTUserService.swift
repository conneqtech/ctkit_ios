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
        return CTBike.shared.restManager.post(endpoint: "user", data:["username":email, "password":password])
    }
    
    public func patch(user: CTUserModel) -> Observable<CTUserModel> {
        return Observable.empty()
    }
    
    public func fetchWith(identifier: Int) -> Observable<CTUserModel> {
        return CTBike.shared.restManager.get(endpoint: "user/\(identifier)", parameters: nil)
    }
    
    public func fetchCurrentUser() -> Observable<CTUserModel> {
        return CTBike.shared.restManager.get(endpoint: "user/me", parameters: nil)
    }
    
    public  func recoverUser(email: String) -> Observable<CTUserModel> {
        return Observable.empty()
    }
    
    public func hasActiveSession() -> Bool {
        return false
    }
    
    public func getActiveUserId() -> Int {
        return 10
    }
    
    public func logout() {
        
    }
}
