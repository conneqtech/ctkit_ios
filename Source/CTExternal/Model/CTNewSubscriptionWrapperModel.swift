//
//  CTNewSubscriptionWrapperModel.swift
//  ctkit
//
//  Created by Inigo Llamosas on 19/10/2022.
//

import Foundation


public struct CTNewSubscriptionWrapperModel: CTBaseModel {
    public let status: CTNewSubscriptionModel?
    
    // Note: we need this init for testing purposes
    public init(status: CTNewSubscriptionModel? = nil) {
        self.status = status
    }
}
