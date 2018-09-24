//
//  UserService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation
import RxSwift

public class CTUserService: NSObject {
    public func login(email: String, password:String) -> Observable<CTUser> {
        let user = CTUser(id: 1, email: "gert-jan@conneqtech.com", firstName: "Gert-Jan", lastName: "Vercauteren")
        return Observable.of(user)
    }
    
    public func create(email: String, password: String) -> Observable<CTUser> {
        let user = CTUser(id: 1, email: email, firstName: "Gert-Jan", lastName: "Vercauteren")
        return Observable.of(user)
    }
    
    public func patch(user: CTUser) -> Observable<CTUser> {
        return Observable.of(user)
    }
    
    public func fetchWithId(identifier: Int) -> Observable<CTUser> {
        let user = CTUser(id: 1, email: "gert-jan@conneqtech.com", firstName: "Gert-Jan", lastName: "Vercauteren")
        return Observable.of(user)
    }
    
    public func fetchCurrentUser() -> Observable<CTUser> {
        let user = CTUser(id: 1, email: "gert-jan@conneqtech.com", firstName: "Gert-Jan", lastName: "Vercauteren")
        return Observable.of(user)
    }
    
    public  func recoverUser(email: String) -> Observable<CTUser> {
        let user = CTUser(id: 1, email: "gert-jan@conneqtech.com", firstName: "Gert-Jan", lastName: "Vercauteren")
        return Observable.of(user)
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
