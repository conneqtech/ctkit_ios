//
//  CTUploadService.swift
//  ctkit
//
//  Created by Daan van der Jagt on 11/10/2018.
//

import Foundation
import RxSwift
import Alamofire
import UIKit

/**
 The CTUploadService is the main entrypoint where images can be uploaded.
 
 */
public class CTUploadService: NSObject {

    /**
     Uploads an image to the API using a UIImage.
     
     - Parameter image: The image to upload.
     - Returns: The upload result, you can use downloadUrl from the object to get access to the uploaded file.
    */
    public func uploadImage(withImage image: UIImage) -> Observable<CTUploadedFile> {
        return CTKit.shared.restManager.upload(endpoint: "upload", image: image).map { (result: [CTUploadedFile]) in
            return result[0]
        }
    }
}
