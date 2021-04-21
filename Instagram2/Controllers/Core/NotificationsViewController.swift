//
//  NotificationsViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(
            LikeNotificationTableViewCell.self,
            forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        tableView.register(
            FollowNotificationTableViewCell.self,
            forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        tableView.register(
            CommentNotificationTableViewCell.self,
            forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        addSubviews()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
    }

    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(noActivityLabel)
    }
    
    private func configureLayouts() {
        tableView.frame = view.bounds
        
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }
    
    private func fetchNotifications() {
        noActivityLabel.isHidden = false
    }
    
    // MARK: - Objc Methods
    
    

}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    
}
