//
//  AuthManager.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    enum AuthError: Error {
        case failedSigningUp
        case failedSigningIn
    }
    
    private let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    /// Signing the user with the email method
    /// - Parameters:
    ///   - email: String user email
    ///   - password: String user password
    ///   - completion: Tell the caller what is the result.
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        DatabaseManager.shared.findUser(with: email) { [weak self] (user) in
            guard let user = user else {
                completion(.failure(AuthError.failedSigningIn))
                return
            }
            
            self?.auth.signIn(
                withEmail: email,
                password: password) { (result, error) in
                guard result != nil, error == nil else {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    else {
                        completion(.failure(AuthError.failedSigningIn))
                        return
                    }
                }
                
                UserDefaults.standard.setValue(user.email, forKey: "email")
                UserDefaults.standard.setValue(user.username, forKey: "username")
                UserDefaults.standard.set(user.profileImage, forKey: "profileImage")
                completion(.success(user))
            }
            
        }
    }
    
    /// Signing the user with the email method
    /// - Parameters:
    ///   - email: String user email
    ///   - username: String username
    ///   - password: String user password
    ///   - profilePicture: Data? user profile image
    ///   - completion: Tell the caller what is the result.
    public func signUp(
        email: String,
        username: String,
        password: String,
        profilePicture: Data?,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let newUser = User(username: username, email: email, profileImage: profilePicture)
        // Create Account
        auth.createUser(
            withEmail: email,
            password: password) { (result, error) in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                else {
                    completion(.failure(AuthError.failedSigningUp))
                    return
                }
            }
            
            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success {
                    StorageManager.shared.uploadProfilePicture(
                        username:newUser.username,
                        data: newUser.profileImage
                    ) { uploadSuccess in
                        if uploadSuccess {
                            completion(.success(newUser))
                        }
                        else {
                            completion(.failure(AuthError.failedSigningUp))
                        }
                    }
                }
                else {
                    completion(.failure(AuthError.failedSigningUp))
                }
            }
        }
    }
    
    /// Signing out the user from the app
    /// - Parameter completion: We want to know if the user successfully signed out or not
    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
