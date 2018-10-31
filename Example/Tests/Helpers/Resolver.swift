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
        let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        
        return jsonData!
    }
}
