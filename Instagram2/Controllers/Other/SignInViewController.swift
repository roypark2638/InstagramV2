//
//  SignInViewController.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {
    
    private let headerView = SignInHeaderView()
    
    private let emailField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        return field
    }()
    
    private let passwordField: IGTextField = {
        let field = IGTextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.keyboardType = .default
        field.returnKeyType = .continue
        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
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
    
//    private let spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView()
//        spinner.startAnimating()
//        spinner.isHidden = true
//        spinner.color = .lightGray
//        spinner.hidesWhenStopped = true
//        spinner.style = .large
//        return spinner
//    }()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign in"
        view.backgroundColor = .systemBackground
        emailField.delegate = self
        passwordField.delegate = self
        addSubviews()
        addButtonActions()        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
//        view.addSubview(spinner)
    }
    
    private func configureLayouts() {
        headerView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: (view.height - view.safeAreaInsets.top)/3
        )
        
        emailField.frame = CGRect(
            x: 25,
            y: headerView.bottom+20,
            width: view.width-50,
            height: 50
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: emailField.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        signInButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: signInButton.bottom+10,
            width: view.width-50,
            height: 50
        )
        
        termsButton.frame = CGRect(
            x: 25,
            y: createAccountButton.bottom+50,
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
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    

    @objc private func didTapSignIn() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else { return }
        
        // Sign in with AuthManager
        AuthManager.shared.signIn(
            email: email,
            password: password) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    let alert = UIAlertController(
                        title: "Oops",
                        message: "Something went wrong with the log-in. Please try again with the valid input.",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                                        title: "Dismiss",
                                        style: .cancel,
                                        handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.completion = { [weak self] in
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
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

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        return true
    }
}
