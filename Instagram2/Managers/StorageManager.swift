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
            completion(false)
            return
        }
        
        storage.child("\(user.username)/profile_picture.png").putData(data, metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
}
