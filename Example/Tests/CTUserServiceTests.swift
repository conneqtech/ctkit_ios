//
//  CTUserServiceTests.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit

import RxBlocking

class CTUserServiceTests: QuickSpec {
    
    override func spec() {
        describe("RUN") {
            it("crashes") {
                CTBike.configure(withClientId: "test", clientSecret: "ys", baseURL: "tt")
                expect(2) == 2
            }
        }
    }
}

