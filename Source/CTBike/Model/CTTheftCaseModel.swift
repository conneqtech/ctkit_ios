//
//  CTTheftCaseModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTTheftCaseModel: CTBaseModel {

    public let id: Int
    public var caseNumber: String?
    public let partnerCaseNumber: String?

    public let partner: CTTheftCasePartnerModel

    public var bikeId: Int
    public var bikeFrameType: String
    public var bikeType: String
    public var bikeColor: String
    public var bikeAdditionalDetails: String
    public var bikeImages: [String]

    //Owner details
    public var ownerName: String
    public var ownerEmail: String
    public var ownerPhone: String
    public var ownerAddress: String
    public var ownerPostalCode: String
    public var ownerCity: String
    public var ownerCountry: String
    public var reportDate: Date
    public var caseStatus: String
    public var bikeIsInsured: Bool
    public var policeCaseNumber: String
    public let caseFinalized: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case caseNumber = "case_number"
        case partnerCaseNumber = "partner_case_number"
        case partner = "partner"

        case bikeId = "bike_id"
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

    public init(id: Int, caseNumber: String? = nil, partnerCaseNumber: String?, partner: CTTheftCasePartnerModel, bikeId: Int, bikeFrameType: String, bikeType: String, bikeColor: String, bikeAdditionalDetails: String, bikeImages: [String], ownerName: String, ownerEmail: String, ownerPhone: String, ownerAddress: String, ownerPostalCode: String, ownerCity: String, ownerCountry: String, reportDate: Date, caseStatus: String, bikeIsInsured: Bool, policeCaseNumber: String, caseFinalized: Bool) {
        self.id = id
        self.caseNumber = caseNumber
        self.partnerCaseNumber = partnerCaseNumber
        self.partner = partner
        self.bikeId = bikeId
        self.bikeFrameType = bikeFrameType
        self.bikeType = bikeType
        self.bikeColor = bikeColor
        self.bikeAdditionalDetails = bikeAdditionalDetails
        self.bikeImages = bikeImages
        self.ownerName = ownerName
        self.ownerEmail = ownerEmail
        self.ownerPhone = ownerPhone
        self.ownerAddress = ownerAddress
        self.ownerPostalCode = ownerPostalCode
        self.ownerCity = ownerCity
        self.ownerCountry = ownerCountry
        self.reportDate = reportDate
        self.caseStatus = caseStatus
        self.bikeIsInsured = bikeIsInsured
        self.policeCaseNumber = policeCaseNumber
        self.caseFinalized = caseFinalized
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(bikeId, forKey: .bikeId)
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
