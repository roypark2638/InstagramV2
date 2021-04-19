//
//  HomeViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit


/*
 Instead of the TableView, I will use CollectionView
 TableView is little antiquated for this type of layout to achieve
 
 CollectionView makes it easier and simpler how to sections are laid out
 */
class HomeViewController: UIViewController {
    
    // MARK: - Subviews
    
    private var collectionView: UICollectionView?
    
    private var viewModels = [[HomeFeedCellType]]()
    
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Instagram"
        configureCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
        fetchPosts()
    }
    
    // MARK: - Methods
    private func fetchPosts() {
        let currentUser = user
        
        DatabaseManager.shared.posts(for: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    
                    let group = DispatchGroup()
                    
                    posts.forEach { (model) in
                        group.enter()
                        
                        self?.createViewModel(
                            model: model,
                            user: currentUser,
                            completion: { (success) in
                                defer {
                                    group.leave()
                                }
                                if !success {
                                    print("Failed to create ViewModel")
                                }
                            })
                    }
                    
                    group.notify(queue: .main) {
                        self?.collectionView?.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func createViewModel(
        model: Post,
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var postURL: URL?
        var profilePictureURL: URL?
        StorageManager.shared.downloadURL(for: model) { [weak self] (url) in
            defer {
                group.leave()
            }
            postURL = url
        }
        
        StorageManager.shared.profilePictureURL(
            for: user.username) { [weak self] (url) in
            defer {
                group.leave()
            }
            profilePictureURL = url
        }
        
        group.notify(queue: .main) {
            guard let postURL = postURL,
                  let profilePhotoURL = profilePictureURL
            else {
                fatalError("Failed to get urls")
                return
            }
            
            let postData: [HomeFeedCellType] = [
                .poster(
                    viewModel: PosterCollectionViewCellViewModel(
                        username: user.username,
                        profilePictureURL: profilePhotoURL
                    )
                ),
                .post(
                    viewModel: PostCollectionViewCellViewModel(
                        postURL: postURL
                    )
                ),
                .actions(
                    viewModel: PostActionCollectionViewCellViewModel(
                        isLiked: false
                    )
                ),
                .likeCount(
                    viewModel: PostLikesCollectionViewCellViewModel(
                        likers: []
                    )
                ),
                .caption(
                    viewModel: PostCaptionCollectionViewCellViewModel(
                        username: user.username,
                        caption: model.caption
                    )
                ),
                .timestamp(
                    viewModel: PostDateTimeCollectionViewCellViewModel(
                        date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                    )
                )
            ]
            
            self.viewModels.append(postData)
            completion(true)
        }
    }
    
    func configureLayouts() {
        collectionView?.frame = view.bounds
    }
}

// MARK: - HomeViewController Extension
extension HomeViewController {
    func configureCollectionView() {
        let sectionHeight: CGFloat = 240+view.width
        let postHeight: CGFloat = 10
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { (index, _) -> NSCollectionLayoutSection? in
                
                    // Item
                    // Cell for poster
                    let posterItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(60))
                    )
                    // Bigger cell for the post
                    let postItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1))
                    )
                    // Actions cell
                    let actionsItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(40))
                    )
                    // Like count cell
                    let likeCountItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(40))
                    )
                    // Caption cell
                    let captionItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(60))
                    )
                    // Timestamp cell
                    let timestampItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(40))
                    )
                    // Group
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(sectionHeight)),
                        subitems: [
                            posterItem,
                            postItem,
                            actionsItem,
                            likeCountItem,
                            captionItem,
                            timestampItem
                        ]
                    )
                    
                    // Section
                    let section = NSCollectionLayoutSection(group: group)
                    
                    section.contentInsets = NSDirectionalEdgeInsets(
                        top: 3,
                        leading: 0,
                        bottom: 10,
                        trailing: 0
                    )
                    return section
            })
            )
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier)
                
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier)
        
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier)
        
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifier)
        self.collectionView = collectionView
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostCollectionViewCell.identifier,
                    for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                    for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                    for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                    for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self

            cell.configure(with: viewModel)
            return cell
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostDateTimeCollectionViewCell.identifier,
                    for: indexPath
            ) as? PostDateTimeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: - PosterCollectionViewCellDelegate

extension HomeViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell) {
        print("Tapped Username")
        // we need to get that user from the database
        let vc = ProfileViewController(user: User(
                                        username: "testUser",
                                        email: "test@test.com",
                                        profileImage: nil))
//        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func posterCollectionViewCellDidTapProfileImage(_ cell: PosterCollectionViewCell) {
        let vc = ProfileViewController(user: User(
                                        username: "testUser",
                                        email: "test@test.com2",
                                        profileImage: nil))
//        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func posterCollectionViewCellDidTapOption(_ cell: PosterCollectionViewCell) {
        let actionSheet = UIAlertController(
            title: "Post Actions",
            message: nil,
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
                                title: "Cancel",
                                style: .cancel,
                                handler: nil))
        actionSheet.addAction(UIAlertAction(
                                title: "Share Post",
                                style: .default,
                                handler: { _ in
                                    
                                }))
        actionSheet.addAction(UIAlertAction(
                                title: "Report Post",
                                style: .destructive,
                                handler: { _ in
                                    
                                }))
        present(actionSheet, animated: true)
    }
}

// MARK: - PostCollectionViewCellDelegate

extension HomeViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDoubleTapToLike(_ cell: PostCollectionViewCell) {
        print("Did tap to like")
    }
}

// MARK: - PostActionsCollectionViewCellDelegate

extension HomeViewController: PostActionsCollectionViewCellDelegate {
    func PostActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool) {
        // Call DB to update like state
        
        print("Did tap to like")

    }
    
    func PostActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell) {
        print("Did tap to comment")
        let vc = PostViewController()
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func PostActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell) {
        print("Did tap to share")
        let vc = UIActivityViewController(
            activityItems: ["Sharing From Instagram"],
            applicationActivities: [])
        present(vc, animated: true)

    }
}

// MARK: - PostLikesCollectionViewCellDelegate

extension HomeViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell) {
        print("did tap like label")
        let vc = ListViewController()
        vc.title = "Likers"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - PostLikesCollectionViewCellDelegate

extension HomeViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        let vc = PostViewController()
        vc.title = "Caption"
        navigationController?.pushViewController(vc, animated: true)
    }
}
