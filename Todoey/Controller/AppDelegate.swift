//
//  AppDelegate.swift
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    //get called when app gets loaded up(the First happen)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    
    //When something happen(got a call) to the phone while the app is open and can do something to prevent the user losing data
    func applicationWillResignActive(_ application: UIApplication) {
       
        
        
    }

    
    //when app disappears off the screen (press the home button for example)
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("applicationDidEnterBackground")
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    //The App will terminate by system or user triggered
    func applicationWillTerminate(_ application: UIApplication) {
       
        print("applicationWillTerminate")
        
    }


}

