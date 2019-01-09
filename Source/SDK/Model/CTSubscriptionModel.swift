//
//  CTSubscriptionModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 22/12/2018.
//

import Foundation

public struct CTSubscriptionModel:CTBaseModel {
    public let id:Int
    public let userId:Int
    public let bikeId:Int
    public let isCancelled:Bool
    public let paymentStatus:Int
    public let paymentId:String
    public let startDate:Date
    public let endDate:Date
    public let productId:Int

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case userId = "user_id"
        case bikeId = "bike_id"
        case isCancelled = "is_cancelled"
        case paymentStatus = "payment_status"
        case paymentId = "payment_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case productId = "product_id"

    }

}
