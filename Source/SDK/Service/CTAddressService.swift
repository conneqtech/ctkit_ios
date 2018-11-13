//
//  CTAddressService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 13/11/2018.
//

import Foundation
import RxSwift

/**
 The CTAddressService is used for geocoding of addresses in the Netherlands. Future versions might include geocoding in other countries.
 */
public class CTAddressService: NSObject {
    
    /**
      Fetches a list of Address objects that match the given parameters.
     
      - Parameter postalCode:  The postal code. (e.g. "1234 AB")
      - Parameter houseNumber: The house number. (e.g. "41")
      - Parameter countryCode: The country code (e.g. "NL") ISO 3166-1 ALPHA-2 Code.
      - Parameter addition:   An optional addition to the house number. (e.g. "C")
      - Returns: a list of addresses.
     */
    func fetch(withPostalcode postalCode: String, houseNumber: String, countryCode: String, addition: String = "") -> Observable<[CTAddressModel]> {
        return CTKit.shared.restManager.get(endpoint: "postcode", parameters: [
            "postcode":postalCode,
            "house_number": houseNumber,
            "country_code": countryCode,
            "addition": addition
        ])
    }
    
}
