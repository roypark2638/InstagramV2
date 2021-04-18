//
//  PostCollectionViewCell.swift
//  Instagram2
//
//  Created by Roy Park on 4/17/21.
//

import UIKit
import SDWebImage

protocol PostCollectionViewCellDelegate: AnyObject {
    func postCollectionViewCellDoubleTapToLike(_ cell: PostCollectionViewCell)
}

final class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    weak var delegate: PostCollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(
            systemName: "heart.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapToLike))
        tap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        contentView.addSubview(heartImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        let size: CGFloat = 65
        heartImageView.frame = CGRect(
            x: (contentView.width-size)/2,
            y: (contentView.height-size)/2,
            width: size,
            height: size
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func configure(with viewModel: PostCollectionViewCellViewModel) {
        imageView.sd_setImage(
            with: viewModel.postURL,
            completed: nil)
    }
    
    @objc private func didDoubleTapToLike() {
        heartImageView.isHidden = false
        UIView.animate(
            withDuration: 0.4) {
            self.heartImageView.alpha = 1
        } completion: { (done) in
            if done {
                UIView.animate(withDuration: 0.4) {
                    self.heartImageView.alpha = 0
                } completion: { (done) in
                    if done {
                        self.heartImageView.isHidden = true
                    }
                }

            }
        }

        
        delegate?.postCollectionViewCellDoubleTapToLike(self)
    }
}
