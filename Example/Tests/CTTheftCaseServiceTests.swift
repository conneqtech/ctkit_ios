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
            let theftcase = [
                "filters": [
                [
                "type": "or",
                "fieldname": "bike_id",
                "operator": "eq",
                "filter_value": "138"
                ]
                ],
                "order_clauses": [
                [
                "fieldname": "report_date",
                "order": "desc"
                ]
                ],
                "meta": [
                    "limit": 20,
                    "offset": 0,
                    "total_records": 1,
                    "available_filter_fieldnames": [
                    "case_number",
                    "owner_name",
                    "owner_phone",
                    "owner_email",
                    "case_status",
                    "bike_id",
                    "partner_id",
                    "finalized"
                    ],
                    "available_order_fieldnames": [
                    "case_number",
                    "owner_name",
                    "owner_phone",
                    "owner_email",
                    "case_status",
                    "bike_id",
                    "partner_id",
                    "report_date"
                    ]
                ],
                "data": [
                [
                "id": 0,
                "case_number": "9rMBB",
                "partner_case_number": nil,
                "partner_id": 2,
                "partner": [
                "id": 2,
                "name": "G4S",
                "email": "g4s-staging@conneq.tech",
                "phone_number": "09004472274",
                "address": "Hogehilweg 12",
                "postal_code": "1101CD",
                "city": "Amsterdam",
                "country": "NL",
                "logo": "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/logo_g4s.png",
                "descriptions": [
                "de": "Nachdem wir Ihre Daten erhalten haben, werden wir uns mit G4S in Verbindung setzen. Dieser externe Partner sucht fu00fcr uns nach Ihrem Rad und wird alles daran setzen, Ihr geliebtes Fahrrad wiederzufinden!",
                "en": "After receiving your data, we will contact G4S. This third party will locate your bike for us, they will do everything to find your beloved bike again!",
                "nl": "Wanneer we je gegevens ontvangen schakelen we G4S in. Zij zijn onze partner in het opsporingsproces en zullen er alles aan doen om je geliefde fiets terug te vinden!"
                ]
                ],
                "bike_additional_details": "",
                "bike_color": "Zwart",
                "bike_frame_type": "female",
                "bike_type": "Emulator",
                "bike_images": [
                "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/sparta-bikeimage-default-m8i.png"
                ],
                "owner_address": "Edisonweg 41",
                "owner_city": "Vlissingen",
                "owner_country": "NL",
                "owner_email": "example@conneqtech.com",
                "owner_name": "Kees Teft",
                "owner_phone_number": "31612345678",
                "owner_postal_code": "4382NW",
                "report_date": "2018-10-06T13:07:37+0000",
                "case_status": "reported",
                "bike_is_insured": true,
                "bike_id": 0,
                "police_case_number": nil,
                "finalized": false
                ]] as [String : Any]

            it("fetches a certain theftcase") {
                
            }
        }
    }
}
