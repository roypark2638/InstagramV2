//
//  SignInHeaderView.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class SignInHeaderView: UIView {
    
    private var gradientLayer: CALayer?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "text_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = layer.bounds
        
        imageView.frame = CGRect(
            x: (width-200)/2,
            y: 20,
            width: 200,
            height: height-40
        )
    }
    
    private func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    func configure() {
        
    }
  
}
