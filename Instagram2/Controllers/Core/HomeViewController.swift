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
       // mock data
        let postData: [HomeFeedCellType] = [
            .poster(
                viewModel: PosterCollectionViewCellViewModel(
                    username: "roypark",
                    profilePictureURL: URL(string: "https://www.apple.com")!
                )
            ),
            .post(
                viewModel: PostCollectionViewCellViewModel(
                    postURL: URL(string: "https://www.apple.com")!
                )
            ),
            .actions(
                viewModel: PostActionCollectionViewCellViewModel(
                    isLiked: false
                )
            ),
            .caption(
                viewModel: PostCaptionCollectionViewCellViewModel(
                    username: "jasmine",
                    caption: "This is great post!"
                )
            ),
            .timestamp(
                viewModel: PostDateTimeCollectionViewCellViewModel(
                    date: Date()
                )
            )
        ]
        
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    
    private func configureLayouts() {
        collectionView?.frame = view.bounds
    }

    
    let colors: [UIColor] = [.red, .yellow, .blue, .brown, .cyan, .gray, .magenta, .green, .systemPink, .purple]
}

// MARK: - HomeViewController Extension
extension HomeViewController {
    private func configureCollectionView() {
        let sectionHeight: CGFloat = 240+view.width
        
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
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
        self.collectionView = collectionView
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewCompositionalLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            break
        case .post(let viewModel):
            break
        case .actions(let viewModel):
            break
        case .likeCount(let viewModel):
            break
        case .caption(let viewModel):
            break
        case .timestamp(let viewModel):
            break
        }
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        cell.contentView.backgroundColor = colors.randomElement()
        
        return cell
    }
    
    
}
