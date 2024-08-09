//
//  UIDeviceExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit


internal extension UIDevice {

    class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    class func deviceName() -> String {
        return UIDevice.current.name
    }

    class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }

    class func deviceModelReadable() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)

        for child in mirror.children {
            let value = child.value

            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }

        return identifier
    }
}
