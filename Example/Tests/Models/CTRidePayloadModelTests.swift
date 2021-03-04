//
//  CTRidePayloadModelTests.swift
//  Unit test
//
//  Created by Inigo Llamosas on 11/02/2021.
//  Copyright © 2021 Conneqtech. All rights reserved.
//

import XCTest
import CoreLocation
import CoreTelephony

@testable import ctkit

class CTRidePayloadModelTests: XCTestCase {

    var allZerosRidePayload = CTRidePayloadModel(bike: CTBikeModel(), location: CLLocation(), state: [:], carrier: CTCarrier())
    
    var allNonZerosRidePayload = CTRidePayloadModel(bike: CTBikeModel(), location: CLLocation(), state: [:], carrier: CTCarrier())
    
   
    var testRidePayload: [String: Any] =   [
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
    
    private func setAllZeros() {
        // Device.metric
        self.allZerosRidePayload.device?.metric.bmv = 0.0001
        self.allZerosRidePayload.device?.metric.bsoc = 0
        self.allZerosRidePayload.device?.metric.bsocp = -1
        self.allZerosRidePayload.device?.metric.dodom = -2
        
        // Tracker.loc
        self.allZerosRidePayload.tracker.loc.alt = 0
        self.allZerosRidePayload.tracker.loc.ang = 0
        self.allZerosRidePayload.tracker.loc.hdop = 0
        self.allZerosRidePayload.tracker.loc.sp = 0
        self.allZerosRidePayload.tracker.loc.geo.coordinates = [0, 0]
        
        // Tracker.gsm
        self.allZerosRidePayload.tracker.gsm?.cid = 0
        self.allZerosRidePayload.tracker.gsm?.lac = 0
        self.allZerosRidePayload.tracker.gsm?.mcc = 0
        self.allZerosRidePayload.tracker.gsm?.mnc = 0
        
        // Tracker.metric
        self.allZerosRidePayload.tracker.metric?.bbatp = 0
        self.allZerosRidePayload.tracker.metric?.bbatv = 0
        
        // Tracker.config
        self.allZerosRidePayload.tracker.config?.blefwver = "0"
        
        // Device.config
        self.allZerosRidePayload.device?.config?.bdcc = 0
        self.allZerosRidePayload.device?.config?.bfcc = 0
        self.allZerosRidePayload.device?.config?.bfccp = 0
        self.allZerosRidePayload.device?.config?.bser = "0"
        self.allZerosRidePayload.device?.config?.dcontver = "0"
        self.allZerosRidePayload.device?.config?.ddisver = "0"
        self.allZerosRidePayload.device?.config?.dser = "0"
        self.allZerosRidePayload.device?.config?.dswver = "0"
        self.allZerosRidePayload.device?.config?.dtype = "0"
        self.allZerosRidePayload.device?.config?.dwheel = 0
    }
    
    private func setAllNonZeros() {
        // Inside device.metric
        self.allNonZerosRidePayload.device?.metric.bmv = 1.00001
        self.allNonZerosRidePayload.device?.metric.bsoc = 1
        self.allNonZerosRidePayload.device?.metric.bsocp = 010
        self.allNonZerosRidePayload.device?.metric.dodom = 010
        
        // Tracker.loc
        self.allNonZerosRidePayload.tracker.loc.alt = 010
        self.allNonZerosRidePayload.tracker.loc.ang = 010
        self.allNonZerosRidePayload.tracker.loc.hdop = 010
        self.allNonZerosRidePayload.tracker.loc.sp = 010
        self.allNonZerosRidePayload.tracker.loc.geo.coordinates = [010, 010]
        
        // Tracker.gsm
        self.allNonZerosRidePayload.tracker.gsm?.cid = 010
        self.allNonZerosRidePayload.tracker.gsm?.lac = 010
        self.allNonZerosRidePayload.tracker.gsm?.mcc = 010
        self.allNonZerosRidePayload.tracker.gsm?.mnc = 010
        
        // Tracker.metric
        self.allNonZerosRidePayload.tracker.metric?.bbatp = 010
        self.allNonZerosRidePayload.tracker.metric?.bbatv = 010
        
        // Tracker.config
        self.allNonZerosRidePayload.tracker.config?.blefwver = "010"
        
        // Device.config
        self.allNonZerosRidePayload.device?.config?.bdcc = 010
        self.allNonZerosRidePayload.device?.config?.bfcc = 010
        self.allNonZerosRidePayload.device?.config?.bfccp = 010
        self.allNonZerosRidePayload.device?.config?.bser = "010"
        self.allNonZerosRidePayload.device?.config?.dcontver = "010"
        self.allNonZerosRidePayload.device?.config?.ddisver = "010"
        self.allNonZerosRidePayload.device?.config?.dser = "010"
        self.allNonZerosRidePayload.device?.config?.dswver = "010"
        self.allNonZerosRidePayload.device?.config?.dtype = "010"
        self.allNonZerosRidePayload.device?.config?.dwheel = 010
    }
    
    override func setUp() {
        
        self.setAllZeros()
        self.setAllNonZeros()
    }

    func testZerosShouldBeNil() {
        self.allZerosRidePayload.filterOutZeros()
        
        // Inside device.metric
        XCTAssert(self.allZerosRidePayload.device?.metric.bmv == nil)
        XCTAssert(self.allZerosRidePayload.device?.metric.bsoc == nil)
        XCTAssert(self.allZerosRidePayload.device?.metric.bsocp == nil)
        XCTAssert(self.allZerosRidePayload.device?.metric.dodom == nil)
        
        // Tracker.loc
        XCTAssert(self.allZerosRidePayload.tracker.loc.alt == nil)
        XCTAssert(self.allZerosRidePayload.tracker.loc.ang == nil)
        XCTAssert(self.allZerosRidePayload.tracker.loc.hdop == nil)
        XCTAssert(self.allZerosRidePayload.tracker.loc.sp == nil)
        XCTAssert(self.allZerosRidePayload.tracker.loc.geo.coordinates == nil)
        
        // Tracker.gsm
        XCTAssert(self.allZerosRidePayload.tracker.gsm?.cid == nil)
        XCTAssert(self.allZerosRidePayload.tracker.gsm?.lac == nil)
        XCTAssert(self.allZerosRidePayload.tracker.gsm?.mcc == nil)
        XCTAssert(self.allZerosRidePayload.tracker.gsm?.mnc == nil)
        
        // Tracker.metric
        XCTAssert(self.allZerosRidePayload.tracker.metric?.bbatp == nil)
        XCTAssert(self.allZerosRidePayload.tracker.metric?.bbatv == nil)
        
        // Tracker.config
        XCTAssert(self.allZerosRidePayload.tracker.config?.blefwver == nil)
        
        // Device.config
        XCTAssert(self.allZerosRidePayload.device?.config?.bdcc == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.bfcc == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.bfccp == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.bser == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.dcontver == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.ddisver == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.dser == nil)

        XCTAssert(self.allZerosRidePayload.device?.config?.dswver == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.dtype == nil)
        XCTAssert(self.allZerosRidePayload.device?.config?.dwheel == nil)
    }

    func testNonZerosShouldNotBeNil() {
        
        // Inside device.metric
        XCTAssert(self.allNonZerosRidePayload.device?.metric.bmv != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.metric.bsoc != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.metric.bsocp != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.metric.dodom != nil)
        
        // Tracker.loc
        XCTAssert(self.allNonZerosRidePayload.tracker.loc.alt != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.loc.ang != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.loc.hdop != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.loc.sp != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.loc.geo.coordinates != nil)
        
        // Tracker.gsm
        XCTAssert(self.allNonZerosRidePayload.tracker.gsm?.cid != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.gsm?.lac != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.gsm?.mcc != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.gsm?.mnc != nil)
        
        // Tracker.metric
        XCTAssert(self.allNonZerosRidePayload.tracker.metric?.bbatp != nil)
        XCTAssert(self.allNonZerosRidePayload.tracker.metric?.bbatv != nil)
        
        // Tracker.config
        XCTAssert(self.allNonZerosRidePayload.tracker.config?.blefwver != nil)
        
        // Device.config
        XCTAssert(self.allNonZerosRidePayload.device?.config?.bdcc != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.bfcc != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.bfccp != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.bser != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.dcontver != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.ddisver != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.dser != nil)

        XCTAssert(self.allNonZerosRidePayload.device?.config?.dswver != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.dtype != nil)
        XCTAssert(self.allNonZerosRidePayload.device?.config?.dwheel != nil)
    }

    func testNilValuesShouldBeOmitted() throws {
        
        self.allZerosRidePayload.filterOutZeros()
        let data = try JSONEncoder().encode(self.allZerosRidePayload)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let tracker = dictionary["tracker"] as? [String: [String: Any]],
              let loc = tracker["loc"],
              let geo = loc["geo"] as? [String: Any],
              let gsm = tracker["gsm"],
              let tmetric = tracker["metric"],
              let tconfig = tracker["config"],
              let device = dictionary["device"] as? [String: [String: Any]],
              let config = device["config"],
              let metric = device["metric"]
        else {
            XCTFail()
            throw NSError()
        }
        
        XCTAssert(metric["bmv"] == nil)
        XCTAssert(metric["bsoc"] == nil)
        XCTAssert(metric["bsocp"] == nil)
        XCTAssert(metric["dodom"] == nil)
        
        // Tracker.loc
        XCTAssert(loc["alt"] == nil)
        XCTAssert(loc["ang"] == nil)
        XCTAssert(loc["hdop"] == nil)
        XCTAssert(loc["sp"] == nil)
        XCTAssert(geo["coordinates"] == nil)
        
        // Tracker.gsm
        XCTAssert(gsm["cid"] == nil)
        XCTAssert(gsm["lac"] == nil)
        XCTAssert(gsm["mcc"] == nil)
        XCTAssert(gsm["mnc"] == nil)
        
        // Tracker.metric
        XCTAssert(tmetric["bbatp"] == nil)
        XCTAssert(tmetric["bbatv"] == nil)
        
        // Tracker.config
        XCTAssert(tconfig["blefwver"] == nil)
        
        // Device.config
        XCTAssert(config["bdcc"] == nil)
        XCTAssert(config["bfcc"] == nil)
        XCTAssert(config["bfccp"] == nil)
        XCTAssert(config["bser"] == nil)
        XCTAssert(config["dcontver"] == nil)
        XCTAssert(config["ddisver"] == nil)
        XCTAssert(config["dser"] == nil)
        XCTAssert(config["dswver"] == nil)
        XCTAssert(config["dtype"] == nil)
        XCTAssert(config["dwheel"] == nil)
    }
    
    func testNonNilValuesShouldNotBeOmitted() throws {
        
        let data = try JSONEncoder().encode(self.allNonZerosRidePayload)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let tracker = dictionary["tracker"] as? [String: [String: Any]],
              let loc = tracker["loc"],
              let geo = loc["geo"] as? [String: Any],
              let gsm = tracker["gsm"],
              let tmetric = tracker["metric"],
              let tconfig = tracker["config"],
              let device = dictionary["device"] as? [String: [String: Any]],
              let config = device["config"],
              let metric = device["metric"]
        else {
            XCTFail()
            throw NSError()
        }

        XCTAssert(metric["bmv"] != nil)
        XCTAssert(metric["bsoc"] != nil)
        XCTAssert(metric["bsocp"] != nil)
        XCTAssert(metric["dodom"] != nil)
        
        // Tracker.loc
        XCTAssert(loc["alt"] != nil)
        XCTAssert(loc["ang"] != nil)
        XCTAssert(loc["hdop"] != nil)
        XCTAssert(loc["sp"] != nil)
        XCTAssert(geo["coordinates"] != nil)
        
        // Tracker.gsm
        XCTAssert(gsm["cid"] != nil)
        XCTAssert(gsm["lac"] != nil)
        XCTAssert(gsm["mcc"] != nil)
        XCTAssert(gsm["mnc"] != nil)
        
        // Tracker.metric
        XCTAssert(tmetric["bbatp"] != nil)
        XCTAssert(tmetric["bbatv"] != nil)
        
        // Tracker.config
        XCTAssert(tconfig["blefwver"] != nil)
        
        // Device.config
        XCTAssert(config["bdcc"] != nil)
        XCTAssert(config["bfcc"] != nil)
        XCTAssert(config["bfccp"] != nil)
        XCTAssert(config["bser"] != nil)
        XCTAssert(config["dcontver"] != nil)
        XCTAssert(config["ddisver"] != nil)
        XCTAssert(config["dser"] != nil)
        XCTAssert(config["dswver"] != nil)
        XCTAssert(config["dtype"] != nil)
        XCTAssert(config["dwheel"] != nil)
    }
    
    func testConstantsAreThere() throws {
        
        let data = try JSONEncoder().encode(self.allZerosRidePayload)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let ver = dictionary["ver"] as? Int,
              let tracker = dictionary["tracker"] as? [String: [String: Any]],
              let loc = tracker["loc"],
              let geo = loc["geo"] as? [String: Any],
              let type = geo["type"] as? String
        else {
            XCTFail()
            throw NSError()
        }
        
        XCTAssert(ver == 2)
        XCTAssert(type == "Point")
    }
    
    func testAngSmallerThanZero() {
        self.allNonZerosRidePayload.tracker.loc.ang = -1
        self.allNonZerosRidePayload.filterOutZeros()
        XCTAssert(allNonZerosRidePayload.tracker.loc.ang == nil)
    }
}
