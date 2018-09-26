//
//  CTBikeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public class CTBikeService: NSObject {

    public func fetchAll() -> Observable<[CTBikeModel]> {
        return CTBike.shared.restManager.get(endpoint: "bike", parameters: nil)
    }
}
