//
//  AppDelegate.swift
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    //get called when app gets loaded up(the First happen)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        return true
    }

    

    
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    
    
    // MARK: - Core Data stack
    /*****************************************************/
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        
        let container = NSPersistentContainer(name: "DataMode")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    /*****************************************************/

    
    //context is an area where you can change and update your data(like staging area)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

