//
//  CTTheftCaseModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTTheftCaseModel:CTBaseModel {
    public let id:Int
    public let caseNumber:String
    public let partnerCaseNumber:String
    public let partnerId:Int
    //RecoveryPartner
    public let bikeFrameType:String
    public let bikeType:String
    public let bikeColor:String
    public let bikeAdditionalDetails:String
    public let images:[UIImage]
    
    //Owner details
    public let ownerName:String
    public let ownerEmail:String
    public let ownerPhone:String
    public let ownerAddress:String
    public let ownerPostalCode:String
    public let ownerCity:String
    public let ownerCountry:String
    public let reportDate:Date
    public let caseStatus:String
    public let bikeIsInsured:Bool
    public let policeCaseNumber:String
    public let caseFinalized:Bool
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case caseNumber = "case_number"
        case partnerCaseNumber = "partner_case_number"
        case partnerId = "partner_id"
        
        case bikeFrameType = "bike_frame_type"
        case bikeType = "bike_type"
        case bikeColor = "bike_color"
        case bikeAdditionalDetails = "bike_additional_details"
        case images = "bike_images"
        
        case ownerName = "owner_name"
        case ownerEmail = "owner_email"
        case ownerPhone = "owner_phone_number"
        case ownerAddress = "owner_address"
        case ownerPostalCode = "owner_postal_code"
        case ownerCity = "owner_city"
        case ownerCountry = "owner_country"
        case reportDate = "report_date"
        case caseStatus = "case_status"
        case bikeIsInsured = "bike_is_insured"
        case policeCaseNumber = "police_case_number"
        case caseFinalized = "finalized"
    }
    
}
