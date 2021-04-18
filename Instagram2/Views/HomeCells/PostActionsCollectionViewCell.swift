//
//  PostActionsCollectionViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/17/21.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject {
    func PostActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell,
                                                 isLiked: Bool)
    func PostActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell)
    func PostActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell)
}

final class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    
    private let likeButton: UIButton = {
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
        
        contentView.addSubview(likeButton)
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
        likeButton.frame = CGRect(
            x: 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        
        commentButton.frame = CGRect(
            x: likeButton.right + 10,
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
        likeButton.addTarget(
            self,
            action: #selector(didTapLike),
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
        isLiked = viewModel.isLiked
        if viewModel.isLiked {
            let image = UIImage(
                systemName: "heart.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
    
    
    @objc private func didTapLike() {
        if self.isLiked {
            let image = UIImage(
                systemName: "heart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }
        else {
            let image = UIImage(
                systemName: "heart.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        
        delegate?.PostActionsCollectionViewCellDidTapLike(self, isLiked: !isLiked)
        self.isLiked = !isLiked
    }
    
    @objc private func didTapComment() {
        delegate?.PostActionsCollectionViewCellDidTapComment(self)
    }
    
    @objc private func didTapShare() {
        delegate?.PostActionsCollectionViewCellDidTapShare(self)
    }
}
