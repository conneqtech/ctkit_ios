//
//  Resolver.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 29/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ctkit

public class Resolver {
    
    func getJSONForResource(name: String) -> [String:Any] {
        let data = try! JSONSerialization.jsonObject(with: getDataForResource(name: name), options: []) as? [String:Any]
        return data!
    }
    
    func getJSONListForResource(name: String) -> [[String:Any]] {
        let listData = try! JSONSerialization.jsonObject(with: getDataForResource(name: name), options: []) as? [[String:Any]]
        return listData!
    }
    
    func getDataForResource(name: String) -> Data {
        let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
