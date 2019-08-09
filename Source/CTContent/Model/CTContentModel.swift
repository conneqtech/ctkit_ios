//
//  CTContentModel.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 09/08/2019.
//

import Foundation

public enum CTContentType: String, Codable {
    case allStatic // Nothing is swipeable
    case titleStatic // The body and images are swipeable (get them from pages)
    case titleAndBodyStatic // The images are swipeable (get them from pages). The title and body should be gotten from CTContentModel
    case allMoving // Title + Body + Images are swipeable (get them from pages)
}

public struct CTContentModel: CTBaseModel {
    public let title:String?
    public let body:String?
    public let type: CTContentType

    public let imageUrl:String?

    public let pages: [CTContentPageModel]



}
