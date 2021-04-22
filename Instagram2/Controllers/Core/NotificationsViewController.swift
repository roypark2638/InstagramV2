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
        let tableView = UITableView(frame: .zero, style: .grouped)
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
    
    private var viewModels: [NotificationCellType] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        addSubviews()
        tableView.delegate = self
        tableView.dataSource = self
        mockData()
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
    }
    
    private func mockData() {
        noActivityLabel.isHidden = true
        tableView.isHidden = false
        guard let postURL = URL(
                string: "https://iosacademy.io/assets/images/courses/swiftui.png"),
                let iconURL = URL(
                    string: "https://iosacademy.io/assets/images/brand/icon.jpg"
        ) else {
            return
        }
        
        
        viewModels = [
            .like(
                viewModel:
                    LikeNotificationCellViewModel(
                        username: "roypark hc",
                        profilePictureURL: iconURL,
                        postURL: postURL
                    )
            ),
            .comment(
                viewModel:
                    CommentNotificationCellViewModel(
                        username: "roypark hc",
                        profilePictureURL: iconURL,
                        postURL: postURL
                    )
            ),
            .follow(
                viewModel:
                    FollowNotificationCellViewModel(
                        username: "roypark hc",
                        profilePictureURL: iconURL,
                        isCurrentUserFollowing: true
                    )
            )
        ]
        
        tableView.reloadData()
    }
    
    // MARK: - Objc Methods
    
    
    
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        
        switch cellType {
        
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FollowNotificationTableViewCell.identifier,
                for: indexPath
            ) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            
            return cell
            
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LikeNotificationTableViewCell.identifier,
                for: indexPath
            ) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            
            return cell
            
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentNotificationTableViewCell.identifier,
                for: indexPath
            ) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    
}
