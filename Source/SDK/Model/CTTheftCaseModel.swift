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
//    public let images:[UIImage]
    
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
        case data = "data"
        case partner = "partner"
        case id = "id"
        case caseNumber = "case_number"
        case partnerCaseNumber = "partner_case_number"
        case partnerId = "partner_id"
        
        case bikeFrameType = "bike_frame_type"
        case bikeType = "bike_type"
        case bikeColor = "bike_color"
        case bikeAdditionalDetails = "bike_additional_details"
//        case images = "bike_images"
        
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
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let partner = try data.nestedContainer(keyedBy: CodingKeys.self, forKey: .partner)
        
        
        id = try! data.decode(Int.self, forKey: .id)
        partnerId = try! partner.decode(Int.self, forKey: .partnerId)
        partnerCaseNumber = try! partner.decode(String.self, forKey: .partnerCaseNumber)
        caseNumber = try! data.decode(String.self, forKey: .caseNumber)
        bikeFrameType = try! data.decode(String.self, forKey: .bikeFrameType)
        bikeType = try! data.decode(String.self, forKey: .bikeType)
        bikeColor = try! data.decode(String.self, forKey: .bikeColor)
        bikeAdditionalDetails = try! data.decode(String.self, forKey: .bikeAdditionalDetails)
        ownerName = try! data.decode(String.self, forKey: .ownerName)
        ownerEmail = try! data.decode(String.self, forKey: .ownerEmail)
        ownerPhone = try! data.decode(String.self, forKey: .ownerPhone)
        ownerAddress = try! data.decode(String.self, forKey: .ownerAddress)
        ownerPostalCode = try! data.decode(String.self, forKey: .ownerPostalCode)
        ownerCity = try! data.decode(String.self, forKey: .ownerCity)
        ownerCountry = try! data.decode(String.self, forKey: .ownerCountry)
        
        reportDate = try! data.decode(Date.self, forKey: .reportDate)
        caseStatus = try! data.decode(String.self, forKey: .caseStatus)
        bikeIsInsured = try! data.decode(Bool.self, forKey: .bikeIsInsured)
        policeCaseNumber = try! data.decode(String.self, forKey: .policeCaseNumber)
        caseFinalized = try! data.decode(Bool.self, forKey: .caseFinalized)
      
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        var partner = data.nestedContainer(keyedBy: CodingKeys.self, forKey: .partner)
        
        try data.encode(id, forKey: .id)
        try data.encode(partnerId, forKey: .partnerId)
        try data.encode(partnerCaseNumber, forKey: .partnerCaseNumber)
        try data.encode(caseNumber, forKey: .caseNumber)
        try data.encode(bikeFrameType, forKey: .bikeFrameType)
        try data.encode(bikeType, forKey: .bikeType)
        try data.encode(bikeColor, forKey: .bikeColor)
        try data.encode(bikeAdditionalDetails, forKey: .bikeAdditionalDetails)
        try data.encode(ownerName, forKey: .ownerName)
        try data.encode(ownerEmail, forKey: .ownerEmail)
        try data.encode(ownerPhone, forKey: .ownerPhone)
        try data.encode(ownerAddress, forKey: .ownerAddress)
        try data.encode(ownerPostalCode, forKey: .ownerPostalCode)
        try data.encode(ownerCity, forKey: .ownerCity)
        try data.encode(ownerCountry, forKey: .ownerCountry)
        
        
        
        
    }
    
}
