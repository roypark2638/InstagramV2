//
//  PostEditViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/18/21.
//

import UIKit
import CoreImage

class PostEditViewController: UIViewController {
    
    fileprivate var filters = [UIImage]()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
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
        view.backgroundColor = .secondarySystemBackground
        title = "Edit"
        imageView.image = image
        view.addSubview(imageView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        configureFilters()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(didTapNext)
        )
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
//            self.filterImage(image: self.image)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        collectionView.frame = CGRect(
            x: 0,
            y: imageView.bottom+20,
            width: view.width,
            height: 100
        )
    }
    
    private func configureFilters() {
        guard let filterIcon = UIImage(systemName: "camera.filters") else { return }
        filters.append(filterIcon)
    }
    
    private func filterImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(CIImage(cgImage: cgImage), forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return }
        
        let context = CIContext()
        if let outputCGImage = context.createCGImage(
            outputImage, from:
                outputImage.extent
        ) {
            let filteredImage = UIImage(cgImage: outputCGImage)
            
            imageView.image = filteredImage
        }
    }
    
    @objc private func didTapNext() {
        guard let current = imageView.image else { return }
        let vc = CaptionViewController(image: current)
        vc.title = "Add Caption"
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UICollectionViewDataSource
extension PostEditViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell
        else {
            fatalError()
        }
        cell.configure(with: filters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        filterImage(image: image)
    }
}

// MARK: - UICollectionViewDelegate
extension PostEditViewController: UICollectionViewDelegate {
    
}


