//
//  CTTheftCaseStatus.swift
//  ctkit
//
//  Created by Inigo Llamosas on 22/07/2021.
//

import Foundation

public struct CTTheftCaseStatus: CTBaseModel {

    public let caseStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case caseStatus = "case_status"
    }
}
