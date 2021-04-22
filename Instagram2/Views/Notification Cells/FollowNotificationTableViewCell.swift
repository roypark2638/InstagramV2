//
//  FollowNotificationTableViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/21/21.
//

import UIKit

class FollowNotificationTableViewCell: UITableViewCell {
    static let identifier = "FollowNotificationTableViewCell"
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 40
        profilePictureImageView.frame = CGRect(
            x: 10,
            y: (contentView.height - imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        profilePictureImageView.layer.cornerRadius = imageSize/2
        
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: contentView.width - followButton.width - 20,
            y: (contentView.height - followButton.height)/2,
            width: followButton.width + 10,
            height: followButton.height
        )
        
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width-profilePictureImageView.width-followButton.width-40,
            height: contentView.height
        )
        )
        label.frame = CGRect(
            x: profilePictureImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: contentView.height
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.image = nil
        label.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
    }
    
    public func configure(with viewModel: FollowNotificationCellViewModel) {
        label.text = viewModel.username + " started following you."
        profilePictureImageView.sd_setImage(
            with: viewModel.profilePictureURL,
            completed: nil)
        followButton.setTitle(viewModel.isCurrentUserFollowing ? "Unfollow" : "Follow", for: .normal)
        followButton.backgroundColor = viewModel.isCurrentUserFollowing ? .systemBackground : .systemBlue
        followButton.setTitleColor(viewModel.isCurrentUserFollowing ? .label : .white, for: .normal)
    }
    
    @objc private func didTapFollow() {
        
    }
}
