//
//  StorageManager.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = user.profileImage else {
//            completion(false)
            return
        }
        
        storage.child("\(user.username)/profile_picture.png").putData(data, metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data,
              let username = UserDefaults.standard.string(forKey: "username")
              else { return }
        
        storage.child("\(username)/posts/\(id).png").putData(
            data,
            metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
}
