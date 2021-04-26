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
    
    private var headerViewModel: ProfileHeaderViewModel?
    
    private var posts: [Post] = []
    
    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    private var collectionView: UICollectionView?
    
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
        title = user.username
        configureNavigationBar()
        configureCollectionView()
        fetchProfileInfo()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func fetchProfileInfo() {
        let username = user.username
        let group = DispatchGroup()
        
        // Fetch Posts
        group.enter()
        DatabaseManager.shared.posts(for: user) { [weak self] (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                break
            }
        }
        // Fetch Profile Header Info
        var profilePictureURL: URL?
        var buttonType: ProfileButtonType = .edit
        var followers = 0
        var following = 0
        var posts = 0
        var name: String?
        var bio: String?
        
        
        // Counts (post, follower, following)
        group.enter()
        DatabaseManager.shared.getUserCounts(
            username: user.username) { result in
            defer {
                group.leave()
            }
            posts = result.posts
            followers = result.followers
            following = result.following
        }
        
        // Bio, name
        DatabaseManager.shared.getUserInfo(username: user.username) { (userInfo) in
            name = userInfo?.name
            bio = userInfo?.bio
        }
        
        // Profile picture url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { (url) in
            defer {
                group.leave()
            }
            profilePictureURL = url
        }
        
        // if profile is not for current user, get follow state
        if !isCurrentUser {
            // get follow state
            group.enter()
            DatabaseManager.shared.isFollowing(
                targetUsername: user.username) { (isFollowing) in
                defer {
                    group.leave()
                }
                buttonType = .follow(isFollowing: isFollowing)
            }
            
        }
        
        group.notify(queue: .main) {
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureURL: profilePictureURL,
                followerCount: followers,
                followingCount: following,
                postCount: posts,
                buttonType: buttonType,
                bio: bio,
                username: self.user.username,
                name: name
            )
            self.collectionView?.reloadData()
        }
    }
    
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

extension ProfileViewController {
    fileprivate func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout:
                UICollectionViewCompositionalLayout(sectionProvider: { (index, _) -> NSCollectionLayoutSection? in
                    
                    let item = NSCollectionLayoutItem(
                        layoutSize:
                            NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalHeight(1))
                    )
                    
                    item.contentInsets = NSDirectionalEdgeInsets(
                        top: 1,
                        leading: 1,
                        bottom: 1,
                        trailing: 1
                    )
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(0.33)),
                        subitem: item,
                        count: 3
                    )
                
                    let section = NSCollectionLayoutSection(group: group)
                    
                    
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .fractionalWidth(0.7)),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                    ]
                    return section
                })
        )
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView = collectionView
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(with: URL(string:posts[indexPath.row].postURLString))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        if let viewModel = headerViewModel {
            headerView.configure(with: viewModel)
            headerView.countContainerView.delegate = self
        }
        headerView.delegate = self
        return headerView
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        let vc = PostViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: ProfileHeaderCountViewDelegate {
    func profileHeaderCountViewDidTapPosts(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapEditProfile(_ containerView: ProfileHeaderCountView) {
        let vc = EditProfileViewController()
        vc.completion = { [weak self] in
            // refetch header info
            self?.headerViewModel = nil
            self?.fetchProfileInfo()
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapUnfollow(_ containerView: ProfileHeaderCountView) {
        
    }
    
    
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView
    ) {
        guard isCurrentUser else { return } // allowing only current user's profile
        
        let actionSheet = UIAlertController(title: "Change Profile", message: "Update your profile photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose From Photo Library", style: .default, handler: { [weak self] (_) in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] (_) in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadProfilePicture(
            username: user.username,
            data: image.pngData()
        ) { [weak self] (success) in
            if success {
                // doing this on the background cuz fetchProfileInfo is on the main thread.
                print("Successfully updated to the storage")
                self?.headerViewModel = nil
                self?.posts = []
                self?.fetchProfileInfo()
            }
            else {
                print("failed to update the profile picture to storage")
            }
        }
        
        
    }
}
