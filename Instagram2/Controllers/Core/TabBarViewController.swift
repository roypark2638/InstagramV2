//
//  TabBarViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(AuthManager.shared.isSignedIn)
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let username = UserDefaults.standard.string(forKey: "username")
        else {
            return
        }
        let profileImage = UserDefaults.standard.data(forKey: "profileImage")
        
        let currentUser = User(
            username: username,
            email: email,
            profileImage: profileImage
        )

        // Define VCs
        let home = HomeViewController(user: currentUser)
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notification = NotificationsViewController()
        let profile = ProfileViewController(user: currentUser)
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: camera)
        let nav4 = UINavigationController(rootViewController: notification)
        let nav5 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        
        if #available(iOS 14.0, *) {
            home.navigationItem.backButtonDisplayMode = .minimal
            explore.navigationItem.backButtonDisplayMode = .minimal
            camera.navigationItem.backButtonDisplayMode = .minimal
            notification.navigationItem.backButtonDisplayMode = .minimal
            profile.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            nav1.navigationItem.backButtonTitle = ""
            nav2.navigationItem.backButtonTitle = ""
            nav3.navigationItem.backButtonTitle = ""
            nav4.navigationItem.backButtonTitle = ""
            nav5.navigationItem.backButtonTitle = ""
        }
        
        // Define tab items
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "camera"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(systemName: "bell"), tag: 1)
        nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        // Set controllers
        
        self.setViewControllers([nav1, nav2, nav3, nav4, nav5],
                                animated: false)
    }
    


}
