//
//  File.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 18/06/2020.
//

import Foundation
import RxSwift

public class CTTroubleshootingService: NSObject, CTTroubleshootingServiceable {
    public func getBikeStatus(withIdentifier identifier: Int) -> Observable<[CTTroubleshootingModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)/health")
    }
}
