//
//  CTPhoneAsAGpsServiceTests.swift
//  ctkit_Tests
//
//  Created by Inigo Llamosas on 04/03/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

@testable import ctkit

class CTPhoneAsAGpsServiceTests: XCTestCase {

    var user: CTUserModel? = nil
    var bike: CTBikeModel? = nil
    
    var payload: [String: Any] =   [
         "ver": 2, //hardcoded 2
         "imei": 111100000000038, //imei of bike as int
         "ttype": "CT", // CTKit as tracker type
         "pver": "1.0", // PVer can be CTKit version, or just 1.0
         "tracker": [
             "loc": [
                 "alt": 39, //altitude in meters as integer
                 "ang": 54, //angle int between 0-359
                 "hdop": 1, // hdop value if available (lookup hdop)
                 "sp": 12, //speed in km/h
                 "geo": [ //GeoJSON spec Point type
                     "coordinates": [
                         4.894409179687499, //longitude as float
                         52.373922404495474 //latitude as float
                     ],
                     "type": "Point" //hardcoded
                 ]
             ],
             "gsm": [ // If available from device API's
                 "cid": 4651, //cell tower ID
                 "lac": 10173,
                 "mcc": 460,
                 "mnc": 0
             ],
             "metric": [
                 "bbatp": 99,          // 1053 - Backup Battery Percentage
                 "bbatv": 4.1,         // 1053 - Backup Battery Voltage
             ],
             "config": [
                 "blefwver": "1.04",   // 1020 - BLE Version
             ]
         ],
         "device": [ // If connected to BLE
             "config": [
                 "bdcc": 14000,        // 1020 - Bike design capacity
                 "bfcc": 50000,        // 1053 - Bike Battery FCC mAh/mWh
                 "bfccp": 100,         // 1053 - Bike Battery FCC Percentage
                 "bser": "GA18220012", // 1020 - Serial number battery
                 "dcontver": "1.08",   // 1020 - Controller software version
                 "ddisver": "1.09",    // 1020 - Display software version
                 "dser": "AC1234567",  // 1020 - Serial number bike
                 "dswver": "S0312",    // 1020 - Bike software version
                 "dtype": "11.01.01",  // 1020 - Bike Type
                 "dwheel": 220,        // 1020 - Wheel diameter
             ],
             "metric": [
                 "bcur": -1000,        // 1053 - Bike Battery Actual Current
                 "bcyc": 114,          // 1053 - Bike Battery Charging Cycles
                 "berr": "3EF",        // 1053 - Battery Errors
                 "bmv": 32.036,        // 1053 - Bike Battery Pack Voltage (min value 1). Exposed in BLE as bpackv
                 "bsoc": 99,           // 1051 - Bike Battery SOC mAh/mWh (min value 1)
                 "bsocp": 90,          // 1051 - Bike Battery SOC Percentage (min value 1)
                 "bstate": 2,          // 1053 - Battery State
                 "btemp": 40,          // 1053 - Bike Battery temperature
                 "dactualsp": 27,      // 1051 - Speed
                 "deculock": false,    // 1051 - ECU Lock Status
                 "derllock": true,     // 1051 - ERL Lock Status
                 "dlight": true,       // 1051 - Light status
                 "dodom": 8400,        // 1051 - Odometer (in m) (min value 1)
                 "dpedcad": 15,        // 1054 - Pedal cadence
                 "dpedpow": 75,        // 1054 - Pedal power
                 "drange": 90,         // 1051 - Range
                 "dstatus": true,      // 1051 - Bike status
                 "dwheels": 25,        // 1054 - Bike wheel speed
                 "mactorq": 30,        // 1054 - Actual Torque
                 "merr": "3EF",        // 1054 - Motor Errors
                 "mpow": 250,          // 1054 - Motor Power
                 "msupp": 5            // 1051 - Support mode
             ]
         ]
    ]
     
    
    override func setUp() {
        do {
            self.user = try CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            self.bike = try CTBikeService().fetchOwned().toBlocking().first()?.filter({ $0.frameIdentifier == "NONC005" }).first
            self.payload["imei"] = bike?.imei
        } catch {
            print(error)
            XCTFail()
        }
    }

    override func tearDown() {
        CTUserService().logout()
    }
    
    func testPostPayload() {
        
        guard let bike = self.bike,
              let user = self.user else { XCTFail()
                                          return }

        // Create ride
        CTKit.shared.restManager.post(endpoint: "v2/bike/\(bike.id)/ride/phone/registerloc", parameters: self.payload)
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 3 seconds")], timeout: 3)

        
        do {
            let busyBikeOpt = try CTBikeService().fetch(withId: bike.id).toBlocking().first()
            guard let busyBike = busyBikeOpt else {
                XCTFail()
                return
            }

            // Test bike is busy
            XCTAssert(busyBike.isRideInProgress == true)
            XCTAssert(busyBike.currentRideUserId == user.id)

            // Post metadata and endride
            CTPhoneAsAGpsService().postMetaData(bike: bike, activeTime: 5, errorMask: 1)
            let newlyCreatedRideOpt = try CTPhoneAsAGpsService().endRide(bike: bike, activeTime: 100).toBlocking().first()
            guard let newlyCreatedRide = newlyCreatedRideOpt else {
                XCTFail()
                return
            }
            XCTAssert(newlyCreatedRide.errorMask == 1)
            XCTAssert(newlyCreatedRide.activeTime == 100)

            // Update ride
            guard let updatedRide = try CTPhoneAsAGpsService().patchNameRating(toRide: newlyCreatedRide, name: "The ride of my life", rating: 4).toBlocking().first() else {
                XCTFail()
                return
            }
            XCTAssert(updatedRide.name == "The ride of my life")
            XCTAssert(updatedRide.rating == 4)
            
        } catch {
            print(error)
             XCTFail()
        }
    }
}
