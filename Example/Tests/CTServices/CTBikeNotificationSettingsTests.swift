//
//  CTBikeNotificationSettingsTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 04/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay
import RxSwift
import RxBlocking

@testable import ctkit

class CTBikeNotificationSettingsTests: XCTestCase {
    
    func testFetchNotifications() {
        let keychain = KeychainSwift()
        keychain.set("dummy", forKey: "accessToken")
        keychain.set("672f03512ae23fc01c0da0bc0612b81d7044a992", forKey: "refreshToken")
        self.stub(http(.get, uri: "/bike/1"), json(Resolver().getJSONForResource(name: "bike"), status: 200))
        let notificationSettings = try! CTBikeService().fetchNotificationSettings(withBikeId: 1).toBlocking().first()!
        
        XCTAssertTrue(notificationSettings.batteryNotify)
        XCTAssertFalse(notificationSettings.motionNotify)
        XCTAssertFalse(notificationSettings.movingNotify)
        XCTAssertTrue(notificationSettings.speedNotify)
    }
}
