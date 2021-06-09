//
//  CTContentModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 09/08/2019.
//

import Foundation



public struct CTContentModel: CTBaseModel {
    public var body: CTContentBodyModel?
    public var pages: [CTContentBodyModel]?
    public var button: CTContentButtonModel?
}
