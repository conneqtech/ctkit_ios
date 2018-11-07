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
