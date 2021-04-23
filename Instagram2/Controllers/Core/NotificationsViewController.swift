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
    
    private var models: [IGNotification] = []
    
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
    
    func openPost(with index: Int, username: String, model: IGNotification) {
        // prevent we accidentally grab higher index.
        guard index < models.count else {
            return
        }
        
        let model = models[index]
        let username = username
        guard let postID = model.postID else { return }
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
            cell.delegate = self
            return cell
            
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LikeNotificationTableViewCell.identifier,
                for: indexPath
            ) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            
            return cell
            
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentNotificationTableViewCell.identifier,
                for: indexPath
            ) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
// MARK: - Actions
// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        let username: String
        switch cellType {
        case .follow(let viewModel):
            username = viewModel.username
            
        case .like(let viewModel):
            username = viewModel.username
            
        case .comment(let viewModel):
            username = viewModel.username
        }
        
        // Fix: update function to use username instead of email
        DatabaseManager.shared.findUser(with: username) { [weak self] (user) in
            guard let user = user else { return }
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - LikeNotificationTableViewCellDelegate

extension NotificationsViewController: LikeNotificationTableViewCellDelegate {
    func likeNotificationTableViewCell(
        _ cell: LikeNotificationTableViewCell,
        didTapPostWith viewModel: LikeNotificationCellViewModel
    ) {
        // we know models and viewModels have same length.
        // we can derive the current index
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .comment, .follow:
                return false
            case .like(let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
        openPost(with: index, username: viewModel.username, model: models[index])
        
        // Find post by id from particular
    }
    
    
}

// MARK: - CommentNotificationTableViewCellDelegate

extension NotificationsViewController: CommentNotificationTableViewCellDelegate {
    func commentNotificationTableViewCell(
        _ cell: CommentNotificationTableViewCell,
        didTapPostWith viewModel: CommentNotificationCellViewModel
    ) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .like, .follow:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
        // we are passing username because the viewModel is going to be different
        openPost(with: index, username: viewModel.username, model: models[index])
        
    }
    
    
}


// MARK: - FollowNotificationTableViewCellDelegate

extension NotificationsViewController: FollowNotificationTableViewCellDelegate {
    func followNotificationTableViewCell(
        _ cell: FollowNotificationTableViewCell,
        didTapButton isFollowing: Bool,
        viewModel: FollowNotificationCellViewModel
    ) {
        
        
    }

}

