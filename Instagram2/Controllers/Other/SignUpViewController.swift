//
//  SignUpViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {
    
    // MARK: - subviews
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    private let emailField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        return field
    }()
    
    private let usernameField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Username"
        field.keyboardType = .default
        field.returnKeyType = .next
        return field
    }()
    
    private let passwordField: IGTextField = {
        let field = IGTextField()
        field.isSecureTextEntry = true
        field.placeholder = "Create Password"
        field.keyboardType = .default
        field.returnKeyType = .continue
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    public var completion: (() -> Void)?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Account"
        view.backgroundColor = .systemBackground
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        addSubviews()
        addButtonActions()
        addImageGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
    }
    
    // MARK: Methods
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func configureLayouts() {
        
        let imageSize: CGFloat = 90
        
        profileImageView.frame = CGRect(
            x: (view.width - imageSize)/2,
            y: view.safeAreaInsets.top + 35,
            width: imageSize,
            height: imageSize
        )
        
        usernameField.frame = CGRect(
            x: 25,
            y: profileImageView.bottom+20,
            width: view.width-50,
            height: 50
        )

        emailField.frame = CGRect(
            x: 25,
            y: usernameField.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: emailField.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        
        termsButton.frame = CGRect(
            x: 25,
            y: signUpButton.bottom+50,
            width: view.width-50,
            height: 30
        )
        
        privacyButton.frame = CGRect(
            x: 25,
            y: termsButton.bottom+10,
            width: view.width-50,
            height: 30
        )
    }
    
    private func addButtonActions() {
        signUpButton.addTarget(self,
                               action: #selector(didTapSignUp),
                               for: .touchUpInside)
        termsButton.addTarget(self,
                              action: #selector(didTapTerms),
                              for: .touchUpInside)
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacy),
                                for: .touchUpInside)
        
    }
    
    private func addImageGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    // MARK:- Objc Methods
    
    @objc private func didTapImage() {
        let actionSheet = UIAlertController(title: "Add Image", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose From Photo Library", style: .default, handler: { [weak self] (_) in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] (_) in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }

    @objc private func didTapSignUp() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let username = usernameField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              username.trimmingCharacters(in: .alphanumerics).isEmpty,
              username.count >= 2
        else {
            let alert = UIAlertController(title: "Oops", message: "Please make sure username doesn't have special characters and it's more than 2 words.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            let alert = UIAlertController(title: "Oops", message: "Please make sure email field.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            let alert = UIAlertController(title: "Oops", message: "Please make sure password is more than 6 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let data = profileImageView.image?.pngData()
        // Sign up with AuthManager
        AuthManager.shared.signUp(
            email: email,
            username: username,
            password: password,
            profilePicture: data) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    
                    self?.navigationController?.popViewController(animated: true)
                    self?.completion?()
                case .failure(let error):
                    print("\n\nSign up error:")
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @objc private func didTapTerms() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapPrivacy() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }


}

// MARK:- UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            didTapSignUp()
        }
        return true
    }
}

// MARK:- UIImagePickerControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profileImageView.image = image
    }
}

// MARK:- UINavigationControllerDelegate

extension SignUpViewController: UINavigationControllerDelegate {
    
}
