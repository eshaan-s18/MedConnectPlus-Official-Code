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


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        return true
    }

    

}
