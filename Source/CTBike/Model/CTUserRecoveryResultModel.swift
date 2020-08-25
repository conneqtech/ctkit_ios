//
//  CTUserRecoveryResultModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/11/2018.
//

import Foundation

struct CTUserRecoveryResultModel: CTBaseModel {
    let success: Bool
    let username: String
    
    public init(success: Bool, username: String) {
        self.success = success
        self.username = username
    }
}
