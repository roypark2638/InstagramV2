//
//  CaptionViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class CaptionViewController: UIViewController {
    
    private let image: UIImage
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Add Caption"
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.font = .systemFont(ofSize: 22)
        return textView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(textView)
        imageView.image = image
        textView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = view.width/4
        imageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top + 30,
            width: imageSize,
            height: imageSize
        )
        
        textView.frame = CGRect(
            x: 20,
            y: imageView.bottom+20,
            width: view.width-40,
            height: 100
        )
    }
    
    @objc private func didTapPost() {
        textView.resignFirstResponder()
        // get the caption out
        var caption = textView.text ?? ""
        if caption == "Add Caption" {
            caption = ""
        }
        
        // upload photo, update database
        
    }
}

extension CaptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Caption" {
            textView.text = nil
        }
    }
}
