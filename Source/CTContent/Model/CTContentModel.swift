//
//  CTContentModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 09/08/2019.
//

import Foundation



public struct CTContentModel: CTBaseModel {
    public let body: CTContentBodyModel?
    public let pages: [CTContentBodyModel]
    public let button: CTContentButtonModel?
}
