//
//  CTRideServiceTests.swift
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

class CTRideServiceTests:QuickSpec {
    override func spec() {
        describe("RideService tests") {
            let ride = [
                "id": 92,
                "start_date": "2018-09-13T01:40:00+0000",
                "end_date": "2018-09-13T01:45:30+0000",
                "calories": 27,
                "avg_speed": 11,
                "distance_traveled": 857,
                "co2": 128,
                "bike_id": 0,
                "user_id": 4,
                "user": [
                    "id": 4,
                    "username": "user@login.bike",
                    "name": nil,
                    "display_name": nil,
                    "first_name": nil,
                    "last_name": nil,
                    "initials": nil,
                    "avatar_url": nil,
                    "address": nil,
                    "city": nil,
                    "country": nil,
                    "postal_code": nil,
                    "house_number": nil,
                    "house_number_addition": nil,
                    "phone_number": nil,
                    "phone_number_formatted": nil,
                    "gender": "m",
                    "is_email_verified": false,
                    "creation_date": "2018-07-16T14:37:33+0000",
                    "location": nil,
                    "registered_on_platform": "sparta"
                ],
                "name": "Vrijetijdsrit",
                "creation_date": "2018-09-17T13:09:02+0000",
                "active_state": 0,
                "weather_info": [
                    "temperature_high": 18.69,
                    "temperature_low": 7.22,
                    "temperature_high_apparent": 18.69,
                    "temperature_low_apparent": 6.03,
                    "lat": 52.254012,
                    "lon": 5.374415,
                    "time": "2018-09-12T22:00:00+0000",
                    "icon_url": "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/weather/partly-cloudy-day.png"
                ],
                "ride_type": "ride.type.leisure"
                ] as [String : Any]
            
            it("fetches a certain ride") {
                var jsonResponse:CTResult<CTRideModel, CTBasicError>?
                self.stub(uri("/bike/ride/92"), json(ride))
                
                try! CTRideService().fetch(withRideId: 262).toBlocking().first().map { (result:CTResult<CTRideModel, CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
            }
            
            it("fetches a list of rides linked to a bike") {
                var jsonResponse:CTResult<[CTRideModel], CTBasicError>?
                self.stub(uri("bike/312/ride"), json([ride, ride, ride]))
                
                try! CTRideService().fetchAll(withBikeId: 312).toBlocking().first().map { (result:CTResult<[CTRideModel], CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
            }
            
            it("creates a new ride for a bike") {
                var jsonResponse:CTResult<CTRideModel, CTBasicError>?
                self.stub(uri("bike/312/ride"), json(ride))
                
                try! CTRideService().create(withBikeId: 312, startDate: Date(), endDate: Date(), rideType: "ride.type.leisure", name: "ride").toBlocking().first().map { (result:CTResult<CTRideModel, CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
            }
        }
    }
}
