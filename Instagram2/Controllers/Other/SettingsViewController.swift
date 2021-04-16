//
//  SettingsViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureNavigationBar()
        createTableFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    private func createTableFooter() {
        let footer = UIView(
            frame:CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: 50)
        )
        footer.clipsToBounds = true
        
        let button = UIButton(frame: footer.bounds)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc private func didTapSignOut() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
                            title: "Cancel",
                            style: .cancel,
                            handler: nil))
        alert.addAction(UIAlertAction(
                            title: "Sign Out",
                            style: .destructive,
                            handler: { _ in
                                AuthManager.shared.signOut { [weak self] (success) in
                                    if success {
                                        // user signed out
                                        DispatchQueue.main.async {
                                            let vc = SignInViewController()
                                            let nav = UINavigationController(rootViewController: vc)
                                            nav.modalPresentationStyle = .fullScreen
                                            self?.present(nav, animated: true)
                                        }
                                    }
                                    else {
                                        // failed to signed out
                                        print("failed to signed out.")
                                    }
                                }
        }))
        
        present(alert, animated: true)
        
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
 

}

// MARK:- UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        cell.backgroundColor = .systemBlue
        return cell
    }
}
