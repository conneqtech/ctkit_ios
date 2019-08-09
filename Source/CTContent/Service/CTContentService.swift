//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import RxSwift

public class CTContentService: NSObject {
    
    public func fetchContent(withIdentifier identifier: String) -> Observable<CTContentModel> {
        return Observable.empty()
    }
}
