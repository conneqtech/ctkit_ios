//
//  CTBikeNotification.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/11/2018.
//

import Foundation

public struct CTBikeNotificationModel {
    public var bikeId:Int?
    public var translatableKey: String?
    public var translationFieldValues: [String]?
    
    
    public init(withBikeId identifier:Int) {
        self.bikeId = identifier
        self.translatableKey = ""
        self.translationFieldValues = []
    }
}
