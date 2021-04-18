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
    
    private func createNewPostID() -> String? {
        let timeStamp = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 0...1000)
        guard let username = UserDefaults.standard.string(forKey: "username")
        else {
            return nil
        }
        
        return "\(username)_\(randomNumber)_\(timeStamp)"
    }
    
    @objc private func didTapPost() {
        textView.resignFirstResponder()
        // get the caption out
        var caption = textView.text ?? ""
        if caption == "Add Caption" {
            caption = ""
        }
        
        // Generate post ID
        guard let postID = createNewPostID(),
              let stringDate = String.date(from: Date())
        else {
            print("failed to generate post ID")
            return }
        
        // Upload Post
        StorageManager.shared.uploadPost(
            data: image.pngData(),
            id: postID) { success in
            guard success else {
                print("error uploading to the storage")
                return
            }
                
            // Update Database
            let newPost = Post(
                id: postID,
                caption: caption,
                postedDate: stringDate,
                likers: []
            )
            DatabaseManager.shared.createPost(
                newPost: newPost) { [weak self] (uploaded) in
                DispatchQueue.main.async {
                    if uploaded {
                        self?.tabBarController?.tabBar.isHidden = false
                        self?.tabBarController?.selectedIndex = 0
                        self?.navigationController?.popToRootViewController(animated: false)
                    }
                    else {
                        // failed to upload to the database
                        print("failed to upload to the database")
                    }
                }
            }
        }
        
        
        
    }
        
}

extension CaptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Caption" {
            textView.text = nil
        }
    }
}
