//
//  CTCloudMessagingService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/11/2018.
//

import Foundation
import RxSwift

public class CTCloudMessagingService: NSObject {
    
    /**
     Register the device to receive cloud messages. The registration happens on our server and communicates with Firebase. When you want to receive message you need to contact Conneqtech to setup the Firebase connection
     
     - Parameter identifier: The device parameter you received from the firebase registration call in the app delegate
     
     - Returns: An observable containing the registered device
     */
    public func registerDevice(withToken identifier: String) -> Observable<CTDeviceModel> {
        return CTKit.shared.restManager.post(endpoint: "device", parameters: [
            "device_identifier": identifier,
            "device_type": "iOS"
            ])
    }
    
    /**
     Parse an incoming push message into a model you can use to create a push notification.
     
     - Parameter userInfo: The userInfo object received in `handleRemoteNotification`
     */
    public func handleRemoteMessage(withUserInfo userInfo: [AnyHashable: Any]) -> CTBikeNotificationModel? {
        if let bike = userInfo["bike_id"] as? Int {
            let notification = CTBikeNotificationModel()
            notification.bikeId = bike
            
            if let alert:Dictionary<String, AnyObject> = userInfo["alert"] as? Dictionary<String, AnyObject> {
                if let locKey:String = alert["loc-key"] as? String {
                    
                    notification.translatableKey = locKey
                    
                    if var args:[String] = (alert["loc-args"] as? [String]) , args.count > 1 {
                        notification.translationFieldValues = args
                    }
                }
            }
            
            return notification
        }
        
        //If there is no bike id, there is no notification to parse for us.
        return nil
    }
    
}


private extension String {
    func localized() -> String {
        // Fetch from database
        if let fromRealm:Localization = ConneqtechSDK.realm.object(ofType: Localization.self, forPrimaryKey: self), self != fromRealm.value {
            return fromRealm.value
        }
        // Fetch from localized bundle
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            return customLocalized(key: self, bundle: bundle)
        }
            // Fetch from base bundle
        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return customLocalized(key: self, bundle: bundle)
        }
        return self
    }
    
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized() as NSString, argument) as String
    }
    
    func customLocalized(key:String, bundle: Bundle) -> String {
        // Try to fetch from custom table
        var result = bundle.localizedString(forKey: key, value: nil, table: "Custom")
        
        // Fetch from default table
        if result == key {
            result = bundle.localizedString(forKey: key, value: nil, table: nil)
        }
        
        return result
    }
}
