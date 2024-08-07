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
    
    static func getAllNewSubscriptions(allSubscriptionWrappers: [CTNewSubscriptionWrapperModel]) -> [CTNewSubscriptionModel] {
        var allSubscriptions: [CTNewSubscriptionModel] = []
        for sub in allSubscriptionWrappers {
            if let s = sub.status {
                allSubscriptions.append(s)
                if let n = s.next {
                    allSubscriptions.append(n)
                }
            }
        }
        return allSubscriptions
    }
}
