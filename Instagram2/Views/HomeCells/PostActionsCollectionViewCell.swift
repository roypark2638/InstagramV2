//
//  PostActionsCollectionViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/17/21.
//

import UIKit

final class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(heartButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        addButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 30
        heartButton.frame = CGRect(
            x: 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        
        commentButton.frame = CGRect(
            x: heartButton.right + 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        
        shareButton.frame = CGRect(
            x: commentButton.right + 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addButtonActions() {
        heartButton.addTarget(
            self,
            action: #selector(didTapHeart),
            for: .touchUpInside
        )
        commentButton.addTarget(
            self,
            action: #selector(didTapComment),
            for: .touchUpInside
        )
        shareButton.addTarget(
            self,
            action: #selector(didTapShare),
            for: .touchUpInside
        )
    }
    
    public func configure(with viewModel: PostActionCollectionViewCellViewModel) {
        if viewModel.isLiked {
            let image = UIImage(
                systemName: "heart.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            heartButton.setImage(image, for: .normal)
            heartButton.tintColor = .systemRed
        }
    }
    
    
    @objc private func didTapHeart() {
        
    }
    
    @objc private func didTapComment() {
        
    }
    
    @objc private func didTapShare() {
        
    }
}
