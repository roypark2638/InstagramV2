//
//  PosterCollectionViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/17/21.
//

import UIKit
import SDWebImage

protocol PosterCollectionViewCellDelegate: AnyObject {
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell)
    func posterCollectionViewCellDidTapProfileImage(_ cell: PosterCollectionViewCell)
    func posterCollectionViewCellDidTapOption(_ cell: PosterCollectionViewCell)
}

final class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    weak var delegate: PosterCollectionViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "ellipsis",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(optionButton)
        let usernameTap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapUsername))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(usernameTap)
        
        let profileTap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileTap)
        
        optionButton.addTarget(
            self,
            action: #selector(didTapOption),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 8
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        profileImageView.frame = CGRect(
            x: imagePadding,
            y: imagePadding,
            width: imageSize,
            height: imageSize
        )
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = imageSize/2
        
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(
            x: profileImageView.right + 10,
            y: 0,
            width: usernameLabel.width,
            height: contentView.height
        )
        
        
        optionButton.frame = CGRect(
            x: contentView.right - 60,
            y: (contentView.height - 50)/2,
            width: 50,
            height: 50
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
    }
    
    public func configure(with viewModel: PosterCollectionViewCellViewModel) {
        usernameLabel.text = viewModel.username
        profileImageView.sd_setImage(
            with: viewModel.profilePictureURL,
            completed: nil
        )
    }
    
    @objc private func didTapOption() {
        delegate?.posterCollectionViewCellDidTapOption(self)
    }
    
    @objc private func didTapUsername() {
        delegate?.posterCollectionViewCellDidTapUsername(self)
    }
    
    @objc private func didTapProfileImage() {
        delegate?.posterCollectionViewCellDidTapProfileImage(self)
    }
}
