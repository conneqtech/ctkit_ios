//
//  CTTheftCaseServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Quick
import Nimble
import RxBlocking
import Mockingjay
import ctkit

class CTTheftCaseServiceTests: QuickSpec {
    
    override func spec() {
        describe("Theftcase tests") {
            var url = Bundle(for: type(of: self)).url(forResource: "theftcase", withExtension: "json")!
            let theftCaseData = try! Data(contentsOf: url)
            
            var otherUrl = Bundle(for: type(of: self)).url(forResource: "theftcaselist", withExtension: "json")!
            let theftCaseListData = try! Data(contentsOf: otherUrl)
            
            
            it("fetches a certain theftcase") {
                var jsonResponse:CTTheftCaseModel?
                self.stub(uri("/theft-case/0"), json(theftCaseData))
                try! CTTheftCaseService().fetch(withCaseId: 0).toBlocking().first().map { (result:CTTheftCaseModel) in
                }
            }
            
//            it("creates a theft case") {
//                var jsonResponse:CTResult<CTTheftCaseModel, CTBasicError>?
//                self.stub(uri("theft-case"), json(theftCase))
//                try! CTTheftCaseService().create(theftCase: CTTheftCaseModel(from: theftCase as! Decoder))
//            }
            
            it("fetches most recent theftcase for bike") {
                var jsonResponse:CTTheftCaseModel?
                self.stub(uri("/theft-case"), json(theftCaseData))
                try! CTTheftCaseService().fetchMostRecent(withBikeId: 0).toBlocking().first().map { (result:CTTheftCaseModel) in

                }
            }
            
            it("fetches theft cases for bike") {
                var jsonResponse:CTResult<[CTTheftCaseModel], CTBasicError>?
                self.stub(uri("/theft-case"), json(theftCaseListData))
                try! CTTheftCaseService().fetchAll(withBikeId: 0).toBlocking().first().map { (result:[CTTheftCaseModel]) in

                }
            }
        }
    }
}
