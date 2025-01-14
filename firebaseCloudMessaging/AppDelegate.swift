//
//  AppDelegate.swift
//  firebaseCloudMessaging
//
//  Created by Higher Visibility on 8/24/16.
//  Copyright © 2016 Buzy Beez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userInfo : String?
    var myViewController: ViewController!
    
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            
            // Register for remote notifications
            //           if #available(iOS 8.0, *) {
                // [START register_for_notifications]
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
                // [END register_for_notifications]
            //} else {
                // Fallback
            // let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            //application.registerForRemoteNotificationTypes(types)
            //}
            
            FIRApp.configure()
            
            // Add observer for InstanceID token refresh callback.
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                                             name: kFIRInstanceIDTokenRefreshNotification, object: nil)
            
            return true
        }
        
        // [START receive_message]
        func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                         fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            
            // Print message ID.
            print("Message ID: \(userInfo["gcm.message_id"]!)")
            
            print("----------Line Break----------")
            
            // Print full message.
            print(userInfo)
            
            // force typecasting
//            let message = userInfo["message"] as! String
            
            // optional binding
            if let message = userInfo["message"] {
                self.userInfo = message as? String
            }
            
            
    }
        // [END receive_message]
    
    
        // [START refresh_token]
        func tokenRefreshNotification(notification: NSNotification) {
            let refreshedToken = FIRInstanceID.instanceID().token()!
            print("InstanceID token: \(refreshedToken)")
            
            // Connect to FCM since connection may have failed when attempted before having a token.
            connectToFcm()
        }
        // [END refresh_token]
    
    
        // [START connect_to_fcm]
        func connectToFcm() {
            FIRMessaging.messaging().connectWithCompletion { (error) in
                if (error != nil) {
                    print("Unable to connect with FCM. \(error)")
                } else {
                    print("Connected to FCM.")
                }
            }
        }
        // [END connect_to_fcm]
        
        func applicationDidBecomeActive(application: UIApplication) {
            connectToFcm()
            
            // assigning the value to the label variable
//            if (self.userInfo != nil) {
//                myViewController.message.text = self.userInfo
//            }
        }
        
        // [START disconnect_from_fcm]
        func applicationDidEnterBackground(application: UIApplication) {
            FIRMessaging.messaging().disconnect()
            print("Disconnected from FCM.")
        }
        // [END disconnect_from_fcm]
}



