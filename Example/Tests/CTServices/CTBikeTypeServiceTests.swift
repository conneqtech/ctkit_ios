//
//  CTBikeTypeServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 15/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import Mockingjay

@testable import ctkit

class CTBikeTypeServiceTests: XCTestCase {

    var features: CTBikeFeatureModel!
    var stubbedBikeType: CTBikeTypeModel!

    override func setUp() {
        features = CTBikeFeatureModel(bluetooth: true,
                                      physicalLock: true,
                                      digitalLock: true,
                                      powerToggle: true,
                                      lightToggle: false,
                                      chargeIndication: true,
                                      lastFullChargeDate: false
        )

        stubbedBikeType = CTBikeTypeModel(id: 1,
                                          type: "ctkitBikeType",
                                          name: "CK300",
                                          registrationFlow: .imei,
                                          catalogPrice: 1800,
                                          secondFactorTranslationKey: "sticker.under.battery",
                                          secondFactorLocationImage: "https://example.com",
                                          defaultSecondFactorLocationImage: "https://example.com",
                                          images: [],
                                          voucherTypeId: 45,
                                          features: features
        )

        self.stub(http(.get, uri: "/bike-type/1"), json(try! stubbedBikeType.asDictionary(), status: 200))
        self.stub(http(.get, uri: "/bike-type/article-number/OTk5OTk5OQ=="), json(["bike_type_id":1], status: 200))
    }

    override func tearDown() {
        let loginSubject = CTUserService()
        loginSubject.logout()
    }

    func test_fetchBikeType_withId() {
        let subjectUnderTest = CTBikeTypeService()
        let result = try! subjectUnderTest.fetchBikeType(withId: 1).toBlocking().first()!

        XCTAssertEqual(result.type, "ctkitBikeType")

        XCTAssertEqual(result.features.bluetooth, true)
        XCTAssertEqual(result.features.physicalLock, true)
        XCTAssertEqual(result.features.digitalLock, true)
        XCTAssertEqual(result.features.powerToggle, true)
        XCTAssertEqual(result.features.lightToggle, false)
        XCTAssertEqual(result.features.chargeIndication, true)
        XCTAssertEqual(result.features.lastFullChargeDate, false)
    }

    func test_fetchBikeType_withArticleNumber() {
        let subjectUnderTest = CTBikeTypeService()
        XCTAssertEqual(try subjectUnderTest.fetchBikeType(withArticleNumber: "9999999").toBlocking().first()?.type, "ctkitBikeType")
    }

    func test_fetchBikeType_fromBikeArticleNumber() {
        let subjectUnderTest = CTBikeService()
        let intermediateSubject = CTBikeTypeService()

        let stubbedBike: [String: Any] = [
            "id":1,
            "imei": "124",
            "frame_number": "test",
            "name": "Test bike",
            "is_requesting_user_owner": true,
            "article_number": "9999999"
        ]

        self.stub(http(.get, uri: "/bike/1"), json(stubbedBike, status: 200))

        let bikeResult = try! subjectUnderTest.fetch(withId: 1).toBlocking().first()!
        let bikeTypeResult = try! intermediateSubject.fetchBikeType(withArticleNumber: bikeResult.articleNumber!).toBlocking().first()!

        XCTAssertEqual(bikeTypeResult.type, "ctkitBikeType")

        XCTAssertEqual(bikeTypeResult.features.bluetooth, true)
        XCTAssertEqual(bikeTypeResult.features.physicalLock, true)
        XCTAssertEqual(bikeTypeResult.features.digitalLock, true)
        XCTAssertEqual(bikeTypeResult.features.powerToggle, true)
        XCTAssertEqual(bikeTypeResult.features.lightToggle, false)
        XCTAssertEqual(bikeTypeResult.features.chargeIndication, true)
        XCTAssertEqual(bikeTypeResult.features.lastFullChargeDate, false)
    }
}
