//
//  CTUploadedFile.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation

public struct CTUploadedFile:CTBaseModel {
    public let isOriginal:Bool
    public let isDefault:Bool
    public let quality:Int
    public let downloadURL:String
    public let creationDate:String

    enum CodingKeys: String, CodingKey {
        case isOriginal = "is_original"
        case isDefault = "is_default"
        case quality = "quality"
        case downloadURL = "download_url"
        case creationDate = "creation_date"
    }
    
    public init(withDownloadURL downloadURL:String, creationDate:Date) {
        self.isOriginal = false
        self.isDefault = false
        self.quality = -1
        self.downloadURL = downloadURL
        self.creationDate = creationDate.toAPIDate()
    }
}
