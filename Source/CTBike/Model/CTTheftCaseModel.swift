//
//  CTTheftCaseModel.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public enum TheftCaseStatus: String {
    case reported
    case inrecovery
    case falseClaim
    case found
    case returned
    case notFound
    case replaced
    case cancelled
}

func getCaseStatus(caseStatusRaw: String?) -> TheftCaseStatus {
    switch caseStatusRaw {
    case "reported":
        return .reported
    case "in recovery":
        return .inrecovery
    case "false claim":
        return .falseClaim
    case "found":
        return .found
    case "returned":
        return .returned
    case "not found":
        return .notFound
    case "replaced":
        return .replaced
    case "cancelled":
        return .cancelled
    default:
        return .reported
    }
}

public struct CaseStatusChange: CTBaseModel {

    public let logDate: Date?
    public let caseStatusRaw: String?
    
    public var status: TheftCaseStatus {
        return getCaseStatus(caseStatusRaw: self.caseStatusRaw)
    }
    
    enum CodingKeys: String, CodingKey {
        case logDate = "log_date"
        case caseStatusRaw = "case_status"
    }

    public init(
        logDate: Date? = nil,
        caseStatusRaw: String? = nil
    ) {
        self.logDate = logDate
        self.caseStatusRaw = caseStatusRaw
    }
}

public struct CTTheftCaseModel: CTBaseModel {

    public let id: Int?
    public var caseNumber: String?

    public var partner: CTTheftCasePartnerModel?

    public var bikeId: Int?
    public var bikeFrameType: String?
    public var bikeType: String?
    public var bikeColor: String?
    public var bikeSecondaryColor: String?
    public var bikeAdditionalDetails: String?
    public var bikeImages: [String]?

    //Owner details
    public var ownerName: String?
    public var ownerEmail: String?
    public var ownerPhone: String?
    public var ownerAddress: String?
    public var ownerPostalCode: String?
    public var ownerCity: String?
    public var ownerCountry: String?
    public var reportDate: Date?
    public var caseStatusRaw: String?
    public var bikeIsInsured: Bool?
    public var policeCaseNumber: String?

    public let caseFinalized: Bool?
    public let linkable: Bool?
    public let cancellable: Bool?

    public var caseStatusLog: [CaseStatusChange]?
    public var contactsUser: Bool?
    public var alwaysReplace: Bool?

    public var status: TheftCaseStatus {
        return getCaseStatus(caseStatusRaw: self.caseStatusRaw)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case caseNumber = "case_number"
        case partner = "partner"

        case bikeId = "bike_id"
        case bikeFrameType = "bike_frame_type"
        case bikeType = "bike_type"
        case bikeColor = "bike_color"
        case bikeSecondaryColor = "bike_secondary_color"
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
        case caseStatusRaw = "case_status"
        case bikeIsInsured = "bike_is_insured"
        case policeCaseNumber = "police_case_number"

        case caseFinalized = "finalized"
        case linkable = "linkable"
        case cancellable = "cancellable"

        case caseStatusLog = "case_status_log"
        case contactsUser = "contacts_user"
        case alwaysReplace = "always_replace"
    }

    public init(
        id: Int = 0,
        caseNumber: String? = nil,
        partner: CTTheftCasePartnerModel? = nil,
        bikeId: Int = 0,
        bikeFrameType: String = "",
        bikeType: String = "",
        bikeColor: String = "",
        bikeSecondaryColor: String = "",
        bikeAdditionalDetails: String = "",
        bikeImages: [String] = [],
        ownerName: String = "",
        ownerEmail: String = "",
        ownerPhone: String = "",
        ownerAddress: String = "",
        ownerPostalCode: String = "",
        ownerCity: String = "",
        ownerCountry: String = "",
        reportDate: Date = Date(),
        caseStatusRaw: String = "",
        bikeIsInsured: Bool = false,
        policeCaseNumber: String = "",
        caseFinalized: Bool = false,
        linkable: Bool = true,
        cancellable: Bool = false,
        caseStatusLog: [CaseStatusChange]? = nil,
        contactsUser: Bool = false,
        alwaysReplace: Bool = false) {
        
        self.id = id
        self.caseNumber = caseNumber
        self.partner = partner
        self.bikeId = bikeId
        self.bikeFrameType = bikeFrameType
        self.bikeType = bikeType
        self.bikeColor = bikeColor
        self.bikeSecondaryColor = bikeColor
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
        self.caseStatusRaw = caseStatusRaw
        self.bikeIsInsured = bikeIsInsured
        self.policeCaseNumber = policeCaseNumber
        self.caseFinalized = caseFinalized
        self.linkable = linkable
        self.cancellable = cancellable
        self.caseStatusLog = caseStatusLog
        self.contactsUser = contactsUser
        self.alwaysReplace = alwaysReplace
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(bikeId, forKey: .bikeId)
        try container.encode(bikeFrameType, forKey: .bikeFrameType)
        try container.encode(bikeType, forKey: .bikeType)
        try container.encode(bikeColor, forKey: .bikeColor)
        try container.encode(bikeSecondaryColor, forKey: .bikeSecondaryColor)
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
        try container.encode(cancellable, forKey: .cancellable)
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int?.self, forKey: .id)
        caseNumber = try container.decode(String?.self, forKey: .caseNumber)
        
        partner = try container.decode(CTTheftCasePartnerModel?.self, forKey: .partner)
        
        bikeId = try container.decode(Int?.self, forKey: .bikeId)
        bikeFrameType = try container.decode(String?.self, forKey: .bikeFrameType)
        bikeType = try container.decode(String?.self, forKey: .bikeType)
        bikeColor = try container.decode(String?.self, forKey: .bikeColor)
        bikeSecondaryColor = try container.decode(String?.self, forKey: .bikeSecondaryColor)
        bikeAdditionalDetails = try container.decode(String?.self, forKey: .bikeAdditionalDetails)
        bikeImages = try container.decode([String]?.self, forKey: .bikeImages)

        reportDate = try container.decode(Date?.self, forKey: .reportDate)
        caseStatusRaw = try container.decode(String?.self, forKey: .caseStatusRaw)
        bikeIsInsured = try container.decode(Bool?.self, forKey: .ownerCountry)
        policeCaseNumber = try container.decode(String?.self, forKey: .policeCaseNumber)
        
        caseFinalized = try container.decode(Bool?.self, forKey: .ownerCountry)
        linkable = try container.decode(Bool?.self, forKey: .ownerCountry)
        cancellable = try container.decode(Bool?.self, forKey: .ownerCountry)
        
        caseStatusLog = try container.decode([CaseStatusChange]?.self, forKey: .caseStatusLog)
        
        contactsUser = try container.decode(Bool?.self, forKey: .ownerCountry)
        alwaysReplace = try container.decode(Bool?.self, forKey: .ownerCountry)
    }
}
