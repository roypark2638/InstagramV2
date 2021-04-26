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
        // Counts (post, follower, following)
        
        // Bio, name
        
        // Profile picture url
        StorageManager.shared.profilePictureURL(for: user.username) { (url) in
            guard let url = url else { return }
        }
        
        // if profile is not for current user, get follow state
        if !isCurrentUser {
            // get follow state
            
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
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(with: UIImage(named: "story1"))
        
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
        let viewModel = ProfileHeaderViewModel(
            profilePictureURL: nil,
            followerCount: 100,
            followingCount: 50,
            postCount: 30,
            buttonType: self.isCurrentUser ? .edit : .follow(isFollowing: true),
            bio: "This is my first profile and hard coded.",
            username: "asdf",
            name: "Roy Park"
        )
        headerView.configure(with: viewModel)
        return headerView
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
//        let post = posts[indexPath.row]
//        let vc = PostViewController(post: post)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
