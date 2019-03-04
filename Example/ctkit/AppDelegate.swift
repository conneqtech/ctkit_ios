//
//  AppDelegate.swift
//  ctkit
//
//  Created by jookes on 09/20/2018.
//  Copyright (c) 2018 jookes. All rights reserved.
//

import UIKit
import ctkit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        CTKit.configure(withClientId: "58e5b0b5-4e5a-47d1-a775-c182fa6b64da", clientSecret: "F2h$7c>9zj;TnpTVG6rHxyJ7dCbC$H{{pxzH8bN6X=2=7HLJJ4", baseURL: "https://axa.api.bike.staging.conneq.tech")
        
        CTKit.shared.addSubscriptions(
            withClientId: "58e5b0b5-4e5a-47d1-a775-c182fa6b64da",
            clientSecret: "F2h$7c>9zj;TnpTVG6rHxyJ7dCbC$H{{pxzH8bN6X=2=7HLJJ4",
            baseURL: "http://api.cb.staging.conneq.tech",
            vendor: "axa")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
