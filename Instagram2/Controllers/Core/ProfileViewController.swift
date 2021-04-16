//
//  ProfileViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

/*
 We want to make sure to reuse this controller not only the current user who is logged in,
 but also use for other profile whom we visited to follow in stuff.
 use initializer and retain the user directly on here before we go ahead super.init
 */
class ProfileViewController: UIViewController {
    
    private let user: User
    
    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Profile"
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showSignedOutUIIfNeeded()
    }
    
//    private func showSignedOutUIIfNeeded() {
//        guard AuthManager.shared.isSignedIn else {
//            return
//        }
        
        // Show Signed Out UI
//        let vc = SignInViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
//    }
    
    private func configureNavigationBar() {
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
