//
//  CTJwtService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 23/07/2019.
//

import Foundation
import RxSwift

class CTJwtService {
    func getJwtForActivityCenter() -> Observable<String> {
        return CTKit.shared.restManager.get(endpoint: "jwt/activitycenter").map { (dict: [String:String]) in
            return dict["token"]!}
    }

    func getJwtForContentAPI() -> Observable<String> {
        return CTKit.shared.restManager.get(endpoint: "jwt/contentapi").map { (dict: [String:String]) in
            return dict["token"]!}
    }
}
