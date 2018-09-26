//
//  CTBike.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

import Foundation

public struct CTBikeModel: CTBaseModel {
    public let id: Int?
    public let imei: String
    public let name: String
    public let state: CTEntityState
    public let frameIdentifier: String // frame_number
    public let keyIdentifier: String // key_number
    public let owner: CTUserModel
    public let linkedUsers: [CTUserModel]
}
