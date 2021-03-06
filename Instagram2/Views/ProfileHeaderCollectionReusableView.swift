//
//  ProfileHeaderCollectionReusableView.swift
//  Instagram2
//
//  Created by Roy Park on 4/25/21.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
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
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .systemBackground
        addSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tap)
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
        
        let bioSize = bioLabel.sizeThatFits(
            CGSize(
                width: width-10,
                height: height-imageSize-10))
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: bioSize.width,
            height: bioSize.height
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
//        bioLabel.textColor = .label
//        bioLabel.text = "\(viewModel.name ?? "")\n\(viewModel.bio ?? "No Bio")"
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "No bio"
        bioLabel.text = text
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
    
    @objc private func didTapImageView() {
        delegate?.profileHeaderCollectionReusableView(self)
    }
}
