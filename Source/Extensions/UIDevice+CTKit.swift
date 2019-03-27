//
//  UIDeviceExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//
#if os(iOS) || os(tvOS)

import UIKit

/// EZSwiftExtensions
private let deviceList = [
    "iPod5,1": "iPod Touch 5",
    "iPod7,1": "iPod Touch 6",
    "iPhone3,1": "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    "iPhone4,1": "iPhone 4S",
    "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    "iPhone7,2": "iPhone 6",
    "iPhone7,1": "iPhone 6 Plus",
    "iPhone8,1": "iPhone 6S",
    "iPhone8,2": "iPhone 6S Plus",
    "iPhone9,1": "iPhone 7", "iPhone9,3": "iPhone 7",
    "iPhone9,2": "iPhone 7 Plus", "iPhone9,4": "iPhone 7 Plus",
    "iPhone8,4": "iPhone SE",
    "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8",
    "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus",
    "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",

    "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
    "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
    "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
    "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
    "AppleTV5,3": "AppleTV",
    "x86_64": "Simulator", "i386": "Simulator"
]

internal extension UIDevice {

    /// EZSwiftExtensions
    internal class func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    /// EZSwiftExtensions - Operating system name
    internal class func systemName() -> String {
        return UIDevice.current.systemName
    }

    /// EZSwiftExtensions - Operating system version
    internal class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// EZSwiftExtensions - Operating system version
    internal class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }

    /// EZSwiftExtensions
    internal class func deviceName() -> String {
        return UIDevice.current.name
    }

    /// EZSwiftExtensions
    internal class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// EZSwiftExtensions
    internal class func deviceModelReadable() -> String {
        return deviceList[deviceModel()] ?? deviceModel()
    }

    /// EZSE: Returns true if the device is iPhone //TODO: Add to readme
    internal class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    /// EZSE: Returns true if the device is iPad //TODO: Add to readme
    internal class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    /// EZSwiftExtensions
    internal class func deviceModel() -> String {
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

    //TODO: Fix syntax, add docs and readme for these methods:
    //TODO: Delete isSystemVersionOver()
    // MARK: - Device Version Checks

    internal enum Versions: Float {
        case five = 5.0
        // swiftlint:disable:next identifier_name
        case six = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine = 9.0
        // swiftlint:disable:next identifier_name
        case ten = 10.0
    }

    internal class func isVersion(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
    }

    internal class func isVersionOrLater(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue
    }

    internal class func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemFloatVersion() < (version.rawValue + 1.0)
    }

    // swiftlint:disable:next identifier_name
    internal class var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }

    // MARK: iOS 5 Checks
    internal class func IS_OS_5() -> Bool {
        return isVersion(.five)
    }

    internal class func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }

    internal class func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }

    // MARK: iOS 6 Checks
    internal class func IS_OS_6() -> Bool {
        return isVersion(.six)
    }

    internal class func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }

    internal class func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }

    // MARK: iOS 7 Checks
    internal class func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }

    internal class func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }

    internal class func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }

    // MARK: iOS 8 Checks
    internal class func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }

    internal class func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }

    internal class func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }

    // MARK: iOS 9 Checks
    internal class func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }

    internal class func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }

    internal class func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }

    // MARK: iOS 10 Checks
    internal class func IS_OS_10() -> Bool {
        return isVersion(.ten)
    }

    internal class func IS_OS_10_OR_LATER() -> Bool {
        return isVersionOrLater(.ten)
    }

    internal class func IS_OS_10_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.ten)
    }

    /// EZSwiftExtensions
    internal class func isSystemVersionOver(_ requiredVersion: String) -> Bool {
        switch systemVersion().compare(requiredVersion, options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            //println("iOS >= 8.0")
            return true
        case .orderedAscending:
            //println("iOS < 8.0")
            return false
        }
    }
}

#endif
