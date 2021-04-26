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
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data else {
            completion(false)
            return
        }
        
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (URL?) -> Void
    ) {
        guard let data = data,
              let username = UserDefaults.standard.string(forKey: "username")
              else { return }
        let reference = storage.child("\(username)/posts/\(id).png")
        reference.putData(
            data,
            metadata: nil) { (_, error) in
            reference.downloadURL { (url, _) in
                completion(url)
            }
        }
    }
    
//    public func downloadURL(
//        for post: Post,
//        completion: @escaping (URL?) -> Void
//    ) {
//        guard let reference = post.storageReference else {
//            completion(nil)
//            return
//        }
//        
//        storage.child(reference).downloadURL { (url, error) in
//            guard error == nil else {
//                print("error downloadURL from Storage \(error!.localizedDescription)")
//                completion(nil)
//                return
//            }
//            completion(url)
//            return
//        }
//    }
    
    public func profilePictureURL(
        for username: String,
        completion: @escaping (URL?) -> Void
    ) {
        storage.child("\(username)/profile_picture.png").downloadURL { (url, error) in
            completion(url)
            return
        }
    }
}
