//
//  AppDelegate.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Add dummy notification for current user
//        let id = NotificationManager.newIdentifier()
//        let model = IGNotification(
//            identifier: id,
//            notificationType: 3,
//            profilePictureURL: "https://iosacademy.io/assets/images/brand/icon.jpg",
//            username: "taylor",
//            dateString: String.date(from: Date()) ?? "Now",
//            isFollowing: false,
//            postID: nil,
//            postURL: nil
//        )
//        NotificationManager.shared.create(notification: model, for: "asdf")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

