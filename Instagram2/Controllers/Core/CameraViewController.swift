//
//  CameraViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Subviews
    
    private var output = AVCapturePhotoOutput()
    private var captureSession: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let cameraView = UIView()

    private let cameraButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = nil
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Post"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(cameraView)
        view.addSubview(cameraButton)
        
        cameraButton.addTarget(
            self,
            action: #selector(didTapTakePhoto),
            for: .touchUpInside
        )
        
        configureNavigationBar()
        checkCameraPermission()
//        configureCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        cameraView.frame = view.bounds
        
        let buttonSize: CGFloat = view.width/5
        cameraButton.frame = CGRect(
            x: (view.width-buttonSize)/2,
            y: view.safeAreaInsets.top + view.width + 100,
            width: buttonSize,
            height: buttonSize
        )
        
        cameraButton.layer.cornerRadius = buttonSize/2
    }
    
    // MARK:- Methods
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.configureCamera()
                }
            }
        case .denied, .restricted:
            break
        case .authorized:
            configureCamera()
        @unknown default:
            break
        }

    }

    private func configureCamera() {
        let captureSession = AVCaptureSession()
        
        // Add device
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                // this canAdd check for conflict of the devices.
                // for example, you can only add one camera at a time(front or back)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            }
            catch {
                print(error)
            }
            
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
                
            }
            
            // Layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            
            cameraView.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
    }
    
    // MARK: - Objc Method
    
    @objc private func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: self
        )
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
              else {
            return
        }
        captureSession?.stopRunning()
        
        
        let vc = PostEditViewController(image: image)
        if #available(iOS 14.0, *) {
            vc.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        navigationController?.pushViewController(vc, animated: false)
    }
}
