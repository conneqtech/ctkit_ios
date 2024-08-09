//
//  CTLocationHistoryService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 03/10/2018.
//

import Foundation
import RxSwift

/**
 The CTBikeLocationService can be used to get the (last known) current location  of the bike and historical bike location data.
 
 This service is the main entry point for all information about a bike's whereabouts.
 */
public class CTBikeLocationService: NSObject {

    /**
     Get all location data of the specified bike between a start and end date (inclusive)
     
     - Note: Asking for a broad range of date (for instance a year) is allowed by the API, but be warned that this might lead to an excessive amount of data points. Until this endpoint is paginated it is advised to be careful when asking for large amounts of data.
     
     - Parameter identifier: The identifier of the bike you want the history of
     - Parameter from: The starting date of the location history
     - Parameter until: The end date of the location history
     
     - Returns: An observable containing the history of the specified bike
     */
    public func fetchHistoryForBike(withId identifier: Int, from: Date, until: Date) -> Observable<[CTBikeLocationModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/location", parameters: [
            "from": from.toAPIDate(),
            "till": until.toAPIDate()
        ])
    }
}
