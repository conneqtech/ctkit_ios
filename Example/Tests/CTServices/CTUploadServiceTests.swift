//
//  CTUploadServiceTest.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 29/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking
import UIKit

class CTUploadServiceTests:QuickSpec {

    override func spec() {
        describe("File upload") {
            it("uploads a file") {
                let image = UIImage(named: "bike")!
                
                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
                let uploadResult = try! CTUploadService().uploadImage(withImage: image).toBlocking().first()
                
                if let res = uploadResult {
                    print(res)
                }
            }
        }
    }
}
