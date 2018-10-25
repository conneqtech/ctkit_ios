//
//  CTGeofenceServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 13/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxBlocking
import RxSwift

class CTGeofenceServiceTests: QuickSpec {
    override func spec() {
  
        describe("Geofence tests") {
            var url = Bundle(for: type(of: self)).url(forResource: "geofence", withExtension: "json")!
            let geofenceData = try! Data(contentsOf: url)
            
            //Json resource for a list of geofences
            url = Bundle(for: type(of: self)).url(forResource: "geofenceList", withExtension: "json")!
            let geofenceListData = try! Data(contentsOf: url)
            
            it("fetches a geofence with id") {
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>?
                self.stub(http(.get, uri: ("/bike/geofence/262")), jsonData(geofenceData))
                try! CTGeofenceService().fetch(withGeofenceId: 262).toBlocking().first().map { (result:CTGeofenceModel) in
                  
                }
               
            }
            
            it("fetches a list of geofences for a bike") {
                var jsonResponse:CTResult<[CTGeofenceModel], CTBasicError>?
                self.stub(http(.get,uri: ("/bike/geofence")), json(geofenceListData))
                
                try! CTGeofenceService().fetchAll(withBikeId: 312).toBlocking().first().map { (result:[CTGeofenceModel]) in
                    
                }
            }
        }
        describe("Geofence create tests") {
            it("creates a new geofence for a bike") {
                var url = Bundle(for: type(of: self)).url(forResource: "geofence", withExtension: "json")!
                let geofenceData = try! Data(contentsOf: url)
                
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>?
                self.stub(http(.post, uri: ("/bike/312/geofence")), jsonData(geofenceData))
                
                try! CTGeofenceService().create(withBikeId: 312, name: "geofence", latitude: 46, longitude: 12, radius: 30).toBlocking().first().map { (result:CTGeofenceModel) in
                  
                }
            }
            
            it("creates an invalid geofence") {
                let url = Bundle(for: type(of: self)).url(forResource: "createGeofenceValidationError", withExtension: "json")!
                let response = try! Data(contentsOf: url)
                
                self.stub(http(.post, uri: ("/bike/312/geofence")), jsonData(response, status: 422))
                
                let callToTest = try! CTGeofenceService().create(withBikeId: 0, name: "", latitude: 0, longitude: 0, radius: 0).toBlocking().first()
             
            }
        }
    }
}
