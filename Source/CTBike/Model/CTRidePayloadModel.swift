//
//  RidePayload.swift
//  Conneqtech
//
//  Created by Inigo Llamosas on 09/02/2021.
//  Copyright © 2021 Conneqtech. All rights reserved.
//

import Foundation
import CoreLocation
import CoreTelephony

public struct CTRidePayloadModel: Codable {
    
    var ver: Int
    var imei: Int
    var ttype: String
    var pver: String
    var tracker: RideTracker
    var device: RideDevice?
    
    public init(bike: CTBikeModel, location: CLLocation?, state: [String: Any], carrier: CTCarrier) {
        
        self.ver = 2
        self.imei = Int(bike.imei)!
        self.ttype = "CT"
        self.pver = "1.0"
        self.tracker = RideTracker(location: location, state: state, carrier: carrier)
        self.device = RideDevice(bike: bike, state: state)
    }
    
    public mutating func filterOutZeros() {
        
        // Inside device.metric
        if let bmv = self.device?.metric.bmv, bmv < 1 {
            self.device?.metric.bmv = nil
        }
        if let bsoc = self.device?.metric.bsoc, bsoc < 1 {
            self.device?.metric.bsoc = nil
        }
        if let bsocp = self.device?.metric.bsocp, bsocp < 1 {
            self.device?.metric.bsocp = nil
        }
        if let dodom = self.device?.metric.dodom, dodom < 1 {
            self.device?.metric.dodom = nil
        }
        
        if let berr = self.device?.metric.berr {
            self.device?.metric.berr = berr.trimmingCharacters(in: .whitespaces)
        }
        
        if let merr = self.device?.metric.merr {
            self.device?.metric.merr = merr.trimmingCharacters(in: .whitespaces)
        }
        
        if let msupp = self.device?.metric.msupp, msupp < 0 {
            self.device?.metric.msupp = nil
        }

        // Tracker.loc
        if self.tracker.loc.alt == 0 {
            self.tracker.loc.alt = nil
        }
        if let ang = self.tracker.loc.ang, ang <= 0 {
            self.tracker.loc.ang = nil
        }
        if self.tracker.loc.hdop == 0 {
            self.tracker.loc.hdop = nil
        }
        if let sp = self.tracker.loc.sp, sp <= 0 {
            self.tracker.loc.sp = nil
        }
        if self.tracker.loc.geo.coordinates?.count == 0 || self.tracker.loc.geo.coordinates?.filter({ $0 > 0 }).count == 0 {
            self.tracker.loc.geo.coordinates = nil
        }

        // Tracker.gsm
        if self.tracker.gsm?.cid == 0 {
            self.tracker.gsm?.cid = nil
        }
        if self.tracker.gsm?.lac == 0 {
            self.tracker.gsm?.lac = nil
        }
        if self.tracker.gsm?.mcc == 0 {
            self.tracker.gsm?.mcc = nil
        }
        if self.tracker.gsm?.mnc == 0 {
            self.tracker.gsm?.mnc = nil
        }

        // Tracker.metric
        if self.tracker.metric?.bbatp == 0 {
            self.tracker.metric?.bbatp = nil
        }
        if self.tracker.metric?.bbatv == 0 {
            self.tracker.metric?.bbatv = nil
        }

        // Tracker.config
        if let tconfig = self.tracker.config, let blefwver = tconfig.blefwver, let intValue = Int(blefwver), intValue == 0 {
            self.tracker.config?.blefwver = nil
        }

        guard let device = self.device, let config = device.config else {
            return
        }

        // Device.config
        if config.bdcc == 0 {
            self.device?.config?.bdcc = nil
        }
        if config.bfcc == 0 {
            self.device?.config?.bfcc = nil
        }
        if config.bfccp == 0 {
            self.device?.config?.bfccp = nil
        }
        if let bser = config.bser, let intValue = Int(bser), intValue == 0 {
            self.device?.config?.bser = nil
        }
        if let dcontver = config.dcontver, let intValue = Int(dcontver), intValue == 0 {
            self.device?.config?.dcontver = nil
        }
        if let ddisver = config.ddisver, let intValue = Int(ddisver), intValue == 0 {
            self.device?.config?.ddisver = nil
        }
        if let dser = config.dser, let intValue = Int(dser), intValue == 0 {
            self.device?.config?.dser = nil
        }
        if let dswver = config.dswver, let intValue = Int(dswver), intValue == 0 {
            self.device?.config?.dswver = nil
        }
        if let dtype = config.dtype, let intValue = Int(dtype), intValue == 0 {
            self.device?.config?.dtype = nil
        }
        if config.dwheel == 0 {
            self.device?.config?.dwheel = nil
        }
    }
}


struct RideGeoCoordinate: Codable {
    var coordinates: [Double]?
    var type: String
    
    init(coordinate: CLLocationCoordinate2D?) {
        if let c = coordinate {
            self.coordinates = [c.longitude, c.latitude]
        }
        self.type = "Point"
    }
}

struct RideLocation: Codable {
    
    var alt: Int?
    var ang: Int?
    var hdop: Int?
    var sp: Int?
    var geo: RideGeoCoordinate
    
    init(location: CLLocation?, state: [String: Any]) {

        if let l = location {
            self.alt = Int(l.altitude)
            self.ang = Int(l.course)
            self.sp = Int(l.speed * 3.6)
        }
        self.geo = RideGeoCoordinate(coordinate: location?.coordinate)
    }
}

struct RideGsm: Codable {
    var cid: Int?
    var lac: Int?
    var mcc: Int?
    var mnc: Int?
    
    init(carrier: CTCarrier) {
        self.mcc = (carrier.mobileCountryCode != nil) ? Int(carrier.mobileCountryCode!) : nil
        self.mnc = (carrier.mobileNetworkCode != nil) ? Int(carrier.mobileNetworkCode!) : nil
    }
}

struct RideTrackerMetric: Codable {
    var bbatp: Int?
    var bbatv: Int?
    
    init(state: [String: Any]) {
        self.bbatp = state["bikeBatterySOCPercentage"] as? Int
        self.bbatv = state["backupBatteryVoltage"] as? Int
    }
}

struct RideTrackerConfig: Codable {
    
    var blefwver: String?
    
    init(state: [String: Any]) {
        self.blefwver = (state["bleVersion"] as? String)
    }
}

struct RideTracker: Codable {
    
    var loc: RideLocation
    var gsm: RideGsm?
    var metric: RideTrackerMetric?
    var config: RideTrackerConfig?
    
    init(location: CLLocation?, state: [String: Any], carrier: CTCarrier) {
        
        self.loc = RideLocation(location: location, state: state)
        self.gsm = RideGsm(carrier: carrier)
        self.metric = RideTrackerMetric(state: state)
        self.config = RideTrackerConfig(state: state)
    }
}

struct RideDevice: Codable {
    var config: RideConfig?
    var metric: RideMetric
    
    init(bike: CTBikeModel, state: [String: Any]) {
        self.config = RideConfig(state: state)
        self.metric = RideMetric(state: state)
    }
}

struct RideConfig: Codable {
    var bdcc: Int?
    var bfcc: Int?
    var bfccp: Int?
    var bser: String?
    var dcontver: String?
    var ddisver: String?
    var dser: String?
    var dswver: String?
    var dtype: String?
    var dwheel: Int?
    
    init(state: [String: Any]) {
        
        self.bdcc = state["bikeDesignCapacity"] as? Int
        self.bfcc = state["bikeBatteryFCC"] as? Int
        self.bfccp = state["bikeBatteryFCCPercentage"] as? Int
        self.bser = state["batterySerialNumber"] as? String
        self.dcontver = state["controllerSoftwareVersion"] as? String
        self.ddisver = state["displaySoftwareVersion"] as? String
        self.dser = state["bikeSerialNumber"] as? String
        self.dswver = state["bikeSoftwareVersion"] as? String
        self.dtype = state["bikeType"] as? String
        self.dwheel = state["wheelDiameter"] as? Int
    }
}

struct RideMetric: Codable {
    
    var bcur: Int?
    var bcyc: Int?
    var berr: String?
    var bmv: Double?
    var bsoc: Int?
    var bsocp: Int?
    var bstate: Int?
    var btemp: Int?
    var dactualsp: Int?
    var deculock: Bool?
    var derllock: Bool?
    var dlight: Bool?
    var dodom: Int64?
    var dpedcad: Int?
    var dpedpow: Int?
    var drange: Int?
    var dstatus: Bool?
    var dwheels: Int?
    var mactorq: Int?
    var merr: String?
    var mpow: Int?
    var msupp: Int?
    
    init(state: [String: Any]) {
        
        self.bcur = state["bikeBatteryActualCurrent"] as? Int
        self.bcyc =  state["bikeBatteryChargingCycles"] as? Int
        self.berr = state["bikeBatteryErrors"] as? String
        self.bmv = state["bikeBatteryPackVoltage"] as? Double
        self.bsoc = state["bikeBatterySOC"] as? Int
        self.bsocp = state["bikeBatteryPercentage"] as? Int
        self.bstate = state["bikeBatteryState"] as? Int
        self.btemp = state["bikeBatteryTemperature"] as? Int
        if let bikeSpeed = state["bikeSpeed"] as? Double {
            self.dactualsp = Int(bikeSpeed)
        }
        self.deculock = (state["ecuLockStatus"] as? Bool)
        self.derllock = (state["erlLockStatus"] as? Bool)
        self.dlight = (state["bikeLightStatus"] as? Bool)
        self.dodom = state["bikeOdometer"] as? Int64
        self.dpedcad = state["pedalCadence"] as? Int
        self.dpedpow = state["pedalPower"] as? Int
        self.drange = state["bikeRange"] as? Int
        self.dstatus = (state["bikeStatus"] as? Bool)
        self.dwheels = state["bikeWheelSpeed"] as? Int
        self.mactorq = state["bikeActualTorque"] as? Int
        self.merr = state["motorErrors"] as? String
        self.mpow = state["motorPower"] as? Int
        self.msupp = state["bikeSupportMode"] as? Int
    }
}
