//
//  AppDelegate.swift
//  todo2
//
//  Created by 冨平準喜 on 2015/08/14.
//  Copyright © 2015年 冨平準喜. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Actions
        let leterAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        leterAction.identifier = "LETER_ACTION"
        leterAction.title = "Leter"
        
        leterAction.activationMode = UIUserNotificationActivationMode.Background
        leterAction.destructive = false
        leterAction.authenticationRequired = false
        
        let deleteAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        deleteAction.identifier = "DELETE_ACTION"
        deleteAction.title = "Delete"
        
        deleteAction.activationMode = UIUserNotificationActivationMode.Background
        deleteAction.destructive = false
        deleteAction.authenticationRequired = false
        
        let openAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        openAction.identifier = "OPEN_ACTION"
        openAction.title = "Open"
        
        openAction.activationMode = UIUserNotificationActivationMode.Background
        openAction.destructive = false
        openAction.authenticationRequired = false
        
        // category
        
        let todoCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        todoCategory.identifier = "TODO_CATEGORY"
        let taskCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        taskCategory.identifier = "TASK_CATEGORY"
        
        let openActions:NSArray = [openAction, deleteAction]
        let taskActions:NSArray = [leterAction, deleteAction]
        
        todoCategory.setActions(openActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        taskCategory.setActions(taskActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
//        let category1:NSSet = NSSet(objects: todoCategory)
//        let category2:NSSet = NSSet(objects: taskCategory)
        let categories = Set(arrayLiteral: todoCategory, taskCategory)

        let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: categories))
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(900)
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let now = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let string = formatter.stringFromDate(now)
        
        print(string)
        
        writeData()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 5
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        notification.alertBody = "open to do list"
        //notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = NSDate()
        notification.category = "TODO_CATEGORY"
        notification.repeatInterval = NSCalendarUnit.Hour
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    /*
    CoreDataへのデータ書き込み
    */
    func writeData(){
        // CoreDataへの書き込み処理.
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let myContext: NSManagedObjectContext = appDel.managedObjectContext
        
        let myEntity: NSEntityDescription! = NSEntityDescription.entityForName("TaskData", inManagedObjectContext: myContext)
        
        let newData = TaskData(entity: myEntity, insertIntoManagedObjectContext: myContext)
        
        let now = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let string = formatter.stringFromDate(now)
        
        newData.task = string
        newData.disc = ""
        
        try! myContext.save()
    }
    
    
    //Schedule the Notifications with repeat
    func scheduleNotification(){
        //schedule the notification
        if(UIApplication.sharedApplication().scheduledLocalNotifications!.count == 0)
        {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            let notification = UILocalNotification()
            notification.alertBody = "open to do list"
            //notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate()
            notification.category = "TODO_CATEGORY"
            notification.repeatInterval = NSCalendarUnit.Hour
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
    }
    
    //MARK: Application Delegate
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
        scheduleNotification()
    }
    
    func application(application: UIApplication,
        handleActionWithIdentifier identifier:String?,
        forLocalNotification notification:UILocalNotification,
        completionHandler: (() -> Void)){
            
            if (identifier == "OPEN_ACTION"){
                
                print("open")
                if(notification.alertBody! as String == "open to do list" && notification.alertBody! as String != "全て消す")
                {
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 5
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                    
                    let items = readData()
                    
                    for tasknum in items
                    {
                        let notification:UILocalNotification = UILocalNotification()
                        notification.category = "TASK_CATEGORY"
                        notification.alertBody = tasknum as String
                        notification.fireDate = NSDate(timeIntervalSinceNow: 0.3)
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    }
                    let notification:UILocalNotification = UILocalNotification()
                    notification.category = "TODO_CATEGORY"
                    notification.alertBody = "全て消す"
                    notification.fireDate = NSDate(timeIntervalSinceNow: 0.3)
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                }
                else if(notification.alertBody! as String == "全て消す")
                {
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 5
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }

                
            }else if (identifier == "DELETE_ACTION"){
                print("delete")
                print(notification.alertBody! as String)
                deleteData(notification.alertBody!)
                
            }
            
            completionHandler()
            
    }
    func readData() -> [NSString]{
        // CoreDataの読み込み処理.
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let myContext: NSManagedObjectContext = appDel.managedObjectContext
        
        let myRequest: NSFetchRequest = NSFetchRequest(entityName: "TaskData")
        myRequest.returnsObjectsAsFaults = false
        
        var myResults: NSArray!
        //var myResults: NSArray! = myContext.executeFetchRequest(myRequest, error: nil)
        
        do {
            myResults = try myContext.executeFetchRequest(myRequest)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        var myItems:[NSString] = []
        
        for myData in myResults {
            myItems.append(myData.valueForKey("task") as! String)
            //myTimes.append(myData.valueForKey("disc") as! String)
            
            print(myData.valueForKey("task") as! String)
            //print(myData.valueForKey("disc") as! String)
        }
        
        return myItems
        
    }
    
    func deleteData(deleteString: NSString)
    {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TaskData")
        if let fetchResults = try!managedObjectContext.executeFetchRequest(fetchRequest) as? [TaskData] {
            for (var i=0; i<fetchResults.count; i++) {
                if fetchResults[i].task ==  deleteString{
                    managedObjectContext.deleteObject(fetchResults[i])
                    try!managedObjectContext.save()
                }
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.toshiki.todo2" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("todo2", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

