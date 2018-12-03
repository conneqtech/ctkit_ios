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
            beforeEach {
                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            }
            
            it("uploads a file") {
                let image = UIImage(named: "samplePng")!
                
                let uploadResult = try! CTUploadService().uploadImage(withImage: image).toBlocking().first()
                
                if let res = uploadResult {
                    expect(res.quality).to(equal(50))
                    expect(res.isOriginal).toNot(beTruthy())
                    expect(res.isDefault).to(beTruthy())
                }
            }
            
            fit("handles the error when the imagesize is too big") {
                let image = UIImage(named: "samplePngHuge")!
                do {
                    _ = try CTUploadService().uploadImage(withImage: image).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.code).to(equal(500))
                        expect(ctError.translationKey).to(equal("api.error.500.internal-server-error"))
                        expect(ctError.description).to(equal("Internal server error"))
                    } else {
                        print("Weird error")
                    }
                }
            }
        }
    }
}
