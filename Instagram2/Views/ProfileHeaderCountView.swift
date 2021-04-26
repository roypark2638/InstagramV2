//
//  ProfileHeaderCountView.swift
//  Instagram2
//
//  Created by Roy Park on 4/25/21.
//

import UIKit

class ProfileHeaderCountView: UIView {
    
    // Count buttons
    
    private let followerCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let followingCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let postCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followerCountButton)
        addSubview(followingCountButton)
        addSubview(postCountButton)
        addSubview(actionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth: CGFloat = (width-15)/3
        
        postCountButton.frame = CGRect(
            x: 5,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        
        followerCountButton.frame = CGRect(
            x: postCountButton.right,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        
        followingCountButton.frame = CGRect(
            x: followerCountButton.right,
            y: 5,
            width: buttonWidth,
            height: height/2
        )
        
        actionButton.frame = CGRect(
            x: 5,
            y: height-42,
            width: width-15,
            height: 40
        )
    }

    public func configure(with viewModel: ProfileHeaderCountViewViewModel) {
        followerCountButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingCountButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        postCountButton.setTitle("\(viewModel.postCount)\nPosts", for: .normal)
        
        switch viewModel.actionType {
        case .edit:
            actionButton.backgroundColor = .systemBackground
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            
        case .follow(isFollowing: let isFollowing):
            actionButton.backgroundColor = isFollowing ? .systemBackground : .systemGreen
            actionButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
            actionButton.setTitleColor(isFollowing ? .label : .white, for: .normal)
            
        }
    }
}
