//
//  CTBikeStateService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 19/06/2019.
//

import Foundation
import RxSwift

/**
 This service is for reading and changing the bike state.
 */
public class CTBikeStateService: NSObject {

    /**
     Fetch the state for the specified bike. All values in the model are nullable.

     - Parameter identifier: The id of the bike you want the state for.
     - Returns: CTBikeStateModel
     */
    public func fetchState(withBikeId identifier: Int) -> Observable<CTBikeStateModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/state")
    }


}
