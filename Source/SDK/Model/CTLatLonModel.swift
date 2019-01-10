//
//  CTLatLonModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 04/10/2018.
//

import Foundation

public struct CTLatLonModel: CTBaseModel {
    public let latitude:Double
    public let longitude:Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
