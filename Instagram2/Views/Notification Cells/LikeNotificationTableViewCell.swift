//
//  LikeNotificationTableViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/21/21.
//

import UIKit

protocol LikeNotificationTableViewCellDelegate: AnyObject {
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell,
                                       didTapPostWith viewModel: LikeNotificationCellViewModel)
}

class LikeNotificationTableViewCell: UITableViewCell {
    static let identifier = "LikeNotificationTableViewCell"
    
    weak var delegate: LikeNotificationTableViewCellDelegate?
    
    private var viewModel: LikeNotificationCellViewModel?
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let postImageView: UIImageView = {
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(label)
        contentView.addSubview(postImageView)
        contentView.addSubview(dateLabel)

        let tap = UIGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tap)
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
            y: 10,
            width: imageSize,
            height: imageSize
        )
        profilePictureImageView.layer.cornerRadius = imageSize/2
        
        
        let postSize: CGFloat = contentView.height - 6
        postImageView.frame = CGRect(
            x: (contentView.width-postSize-10),
            y: 3,
            width: postSize,
            height: postSize
        )
        
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width-profilePictureImageView.width-32-postSize,
                height: contentView.height
            )
        )
        label.frame = CGRect(
            x: profilePictureImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: contentView.height-dateLabel.height-2
        )
        
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(
            x: profilePictureImageView.right + 10,
            y: contentView.height-dateLabel.height-2,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.image = nil
        label.text = nil
        postImageView.image = nil
        dateLabel.text = nil
    }
    
    public func configure(with viewModel: LikeNotificationCellViewModel) {
        self.viewModel = viewModel
        profilePictureImageView.sd_setImage(
            with: viewModel.profilePictureURL,
            completed: nil)
        label.text = "\(viewModel.username) liked your post."
        dateLabel.text = viewModel.date
        postImageView.sd_setImage(with: viewModel.postURL,
                                  completed: nil)
    }
    
    @objc private func didTapPost() {
        guard let viewModel = viewModel else { return }
        delegate?.likeNotificationTableViewCell(self,
                                                didTapPostWith: viewModel)
    }
}
