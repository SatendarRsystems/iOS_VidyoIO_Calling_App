//
//  AppDelegate.swift
//  VIO
//
//  Summary: AppDelegate Component
//  Description: It is a delegate class to provide application life cycle methods.
//
//  Created by Arun Kumar on 25/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import os.log
import PushNotifications
import PusherSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {

    var window: UIWindow?
//    let pushNotifications = PushNotifications.shared
    var pusher: Pusher!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         IQKeyboardManager.sharedManager().enable = true
        let themes = Themes()
        themes.initAppearance()
/*
        //Initialize PusherBeams
        self.pushNotifications.start(instanceId: "2286fa9c-aee0-417e-b360-bc54a961792e")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.subscribe(interest: "hello")
*/
        //Create pusher connection
        let options = PusherClientOptions(
            host: .cluster("ap2")
        )

        pusher = Pusher(key: "3fc75030bf0f36d2bd3f", options: options)
//        pusher.delegate = self
        pusher.connection.delegate = self
        pusher.connect()
        
        //Subscribe pusher public channel
        let myChannel = pusher.subscribe("vidyoChannel")
        
        let _ = pusher.bind({ (message: Any?) in
            os_log("message:- %{public}@", log: .default, type: .debug, String(describing: message))

            if let message = message as? [String: AnyObject], let eventName = message["event"] as? String, eventName == "pusher:error" {
                if let data = message["data"] as? [String: AnyObject], let errorMessage = data["message"] as? String {
                    os_log("errorMessage:- %{public}@", log: .default, type: .debug, errorMessage)
                }
            }
        })
        
        let _ = myChannel.bind(eventName: "my-event", callback: { data in
            os_log("data:- %{public}@", log: .default, type: .debug, String(describing: data))
            
            if let data = data as? [String : AnyObject] {
                
                if let resourceId = data["resourceId"] as? String {
                    Utile.saveMeetingID(resourceId)
                }
                
                if let type = data["type"] as? String, let displayName = data["displayName"] as? String, type.isEqual("initiateCall") {
                    self.displayIncomingCallVC(contactName: displayName)
                } else if let type = data["type"] as? String, let isAccept = data["isAccept"] as? Bool, type.isEqual("acceptRejectCall") {
                    
                    if isAccept == true {
                        
                    } else {
                        
                    }
                }
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        VidyoManager.connector?.setMode(.background)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        VidyoManager.connector?.setMode(.foreground)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        VidyoManager.sharedInstance.disableMeeting()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VIO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
/*
    // MARK: - APNS Integration
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        os_log("deviceToken:- %@", log: .default, type: .debug, String(describing: deviceToken))
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        os_log("userInfo:- %{public}@", log: .default, type: .debug,  userInfo)

        self.pushNotifications.handleNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        os_log("error:- %@", log: .default, type: .debug,  error.localizedDescription)
    }
 */
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        os_log("old:- %{public}@", log: .default, type: .debug, old.stringValue())
        os_log("new:- %{public}@", log: .default, type: .debug, new.stringValue())
    }
    
    func debugLog(message: String) {
        os_log("message:- %{public}@", log: .default, type: .debug, message)
    }
    
    func subscribedToChannel(name: String) {
        os_log("name:- %{public}@", log: .default, type: .debug, name)
    }
    
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        os_log("error:- %{public}@", log: .default, type: .debug, (error?.localizedDescription)!)
    }
    
    // MARK: - Dispaly call screen
    
    func displayIncomingCallVC(contactName: String) {
        if let tabBC = window?.rootViewController as? UITabBarController, let navVC = tabBC.viewControllers?[tabBC.selectedIndex] as? UINavigationController, let lastVC = navVC.viewControllers.last {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let incomingCallVC = storyboard.instantiateViewController(withIdentifier: "IncomingCallVC") as! IncomingCallVC
            incomingCallVC.strContactName = contactName
            lastVC.present(incomingCallVC, animated: true, completion: nil)
        }
    }
}
