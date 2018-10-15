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

class CTGeofenceServiceTests: QuickSpec {
    
    override func spec() {
        beforeEach {
            //Setup code for tests
            //Use mocked networking layer here?
            let service = CTGeofenceService()
            let idToTest = 8248
            var geofenceModel:CTGeofenceModel?
            
            describe(".fetchGeofence") {
                context("Geofence variable is not empty") {
                    //Test mocked call in succes scenario..
                }
                
                context("The given Id does not exist") {
                    //Test call in fail scenario, id that doesn't exist
                }
            }
            
            describe(".fetchAllGeofencesWithBikeId") {
                context("bikeId exists and has atleast 1 geofence") {
                    //Mock fetchAllWithBikeId for existing bike that has atleast one geofence
                }
                
                context("bikeId exists but has no geofences") {
                    //Mock call where bikeId exists but has no geofences
                }
                
                context("bikeId does not exist") {
                    //Mock call where bikeId doesn't existß
                }
            }
        }
    }
    
    
    
}
