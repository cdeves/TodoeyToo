//
//  AppDelegate.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    //NSPersistentContainer is a SQLite database.  Default containers are always of this type (but coudl instead be XML, etc).
    lazy var persistentContainer: NSPersistentContainer = {
        //the container created in this step must match the name of your Data Model file
        let container = NSPersistentContainer(name: "DataModel")
        //load the persistent store
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            //check for errors
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //if no errors, return this container as the value of the lazy variable persistentContainer
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        //the context is a scratchpad where you can update your data before saving it in persistentContainer's permanent storage
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                //save data in the context to permanent storage
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

