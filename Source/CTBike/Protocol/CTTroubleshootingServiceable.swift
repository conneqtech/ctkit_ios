//
//  CTTroubleshootingServiceProtocol.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 17/07/2020.
//

import Foundation
import RxSwift

public protocol CTTroubleshootingServiceable {
    func getBikeStatus(withIdentifier identifier: Int) -> Observable<[CTTroubleshootingModel]>
}
