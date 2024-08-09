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
    public func registerDevice(withToken identifier: String) -> Observable<CTEmptyObjectModel> {
        return CTKit.shared.restManager.post(endpoint: "device", parameters: [
            "device_identifier": identifier,
            "device_type": "iOS"
            ])
    }
}
