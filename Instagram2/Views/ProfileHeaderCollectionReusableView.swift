//
//  ProfileHeaderCollectionReusableView.swift
//  Instagram2
//
//  Created by Roy Park on 4/25/21.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    public let countContainerView = ProfileHeaderCountView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/4
        imageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        imageView.layer.cornerRadius = imageSize/2
        
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3,
            width: width-imageView.right-10,
            height: imageSize
        )
        
        bioLabel.sizeToFit()
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: width-10,
            height: bioLabel.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(countContainerView)
        addSubview(bioLabel)
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel) {
        bioLabel.text = "\(viewModel.name ?? "")\n\(viewModel.bio)"
        imageView.sd_setImage(with: viewModel.profilePictureURL, completed: nil)
        
        // Container
        let containerViewModel = ProfileHeaderCountViewViewModel(
            followerCount: viewModel.followerCount,
            followingCount: viewModel.followingCount,
            postCount: viewModel.postCount,
            actionType: viewModel.buttonType
        )
        countContainerView.configure(with: containerViewModel)
    }
}
