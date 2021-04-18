//
//  PostLikesCollectionViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/17/21.
//

import UIKit

protocol PostLikesCollectionViewCellDelegate: AnyObject {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell)
}

final class PostLikesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostLikesCollectionViewCell"
    
    weak var delegate: PostLikesCollectionViewCellDelegate?
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapLikeLabel))
        likeCountLabel.isUserInteractionEnabled = true
        likeCountLabel.addGestureRecognizer(tap)
        contentView.addSubview(likeCountLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        likeCountLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width-20,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeCountLabel.text = nil
    }
    
    public func configure(with viewModel: PostLikesCollectionViewCellViewModel) {
        let likers = viewModel.likers
        likeCountLabel.text = "\(likers.count) liked"
    }
    
    @objc private func didTapLikeLabel() {
        delegate?.postLikesCollectionViewCellDidTapLikeCount(self)
    }
}
