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
    public let partnerCaseNumber: String?

    public let partner: CTTheftCasePartnerModel

    public let bikeFrameType:String
    public let bikeType:String
    public let bikeColor:String
    public let bikeAdditionalDetails:String
    public let bikeImages:[String]

    //Owner details
    public let ownerName:String
    public let ownerEmail:String
    public let ownerPhone:String
    public let ownerAddress:String
    public let ownerPostalCode:String
    public let ownerCity:String
    public let ownerCountry:String
    public let reportDate:String
    public let caseStatus:String
    public let bikeIsInsured:Bool
    public let policeCaseNumber:String
    public let caseFinalized:Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case caseNumber = "case_number"
        case partnerCaseNumber = "partner_case_number"
        case partner = "partner"

        case bikeFrameType = "bike_frame_type"
        case bikeType = "bike_type"
        case bikeColor = "bike_color"
        case bikeAdditionalDetails = "bike_additional_details"
        case bikeImages = "bike_images"

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
    
    public init(withPartnerCaseNumber partnerCaseNumber:String, partner:CTTheftCasePartnerModel) {
        self.id = -1
        self.caseNumber = ""
        self.partnerCaseNumber = partnerCaseNumber
        self.partner = partner
        self.bikeFrameType = ""
        self.bikeType = ""
        self.bikeColor = ""
        self.bikeAdditionalDetails = ""
        self.bikeImages = []
        
        self.ownerName = ""
        self.ownerEmail = ""
        self.ownerPhone = ""
        self.ownerAddress = ""
        self.ownerPostalCode = ""
        self.ownerCity = ""
        self.ownerCountry = ""
        self.caseStatus = ""
        self.bikeIsInsured = false
        self.caseFinalized = false
        self.reportDate = Date().toAPIDate()
        self.policeCaseNumber = ""
    
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(bikeFrameType, forKey: .bikeFrameType)
        try container.encode(bikeType, forKey: .bikeType)
        try container.encode(bikeColor, forKey: .bikeColor)
        try container.encode(bikeAdditionalDetails, forKey: .bikeAdditionalDetails)
        try container.encode(bikeImages, forKey: .bikeImages)
        try container.encode(ownerName, forKey: .ownerName)
        try container.encode(ownerEmail, forKey: .ownerEmail)
        try container.encode(ownerPhone, forKey: .ownerPhone)
        try container.encode(ownerAddress, forKey: .ownerAddress)
        try container.encode(ownerPostalCode, forKey: .ownerPostalCode)
        try container.encode(ownerCity, forKey: .ownerCity)
        try container.encode(ownerCountry, forKey: .ownerCountry)
        try container.encode(bikeIsInsured, forKey: .bikeIsInsured)
        try container.encode(policeCaseNumber, forKey: .policeCaseNumber)

    }

}
