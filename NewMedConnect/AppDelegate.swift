//
//  AppDelegate.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 5/27/22.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications


var sharedToken = ""

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                        options: authOptions,
                        completionHandler: {_, _ in })
                    // For iOS 10 data message (sent via FCM)
                    Messaging.messaging().delegate = self
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }
                UIApplication.shared.registerForRemoteNotifications()
            

        
        return true
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token = \(token)")
            sharedToken = token
            
        }
    }
    
    

    

}
