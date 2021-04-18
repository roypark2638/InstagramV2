//
//  CaptionViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit

class CaptionViewController: UIViewController {
    
    private let image: UIImage
    
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
    }


}
