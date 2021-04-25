//
//  DatabaseManager.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Firestore.firestore()
    
    public func findUsers(
        with usernamePrefix: String,
        completion: @escaping ([User]) -> Void
    ) {
        let reference = database.collection("users")
        reference.getDocuments { (snapshot, error) in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data())}),
                  error == nil
            else {
                completion([])
                return
            }
            
            let subsets = users.filter({
                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
            })
            
            completion(subsets)
        }
    }
    
    public func createUser(newUser: User, completion: @escaping (Bool) -> Void) {
        let reference = database.document("users/\(newUser.username)")
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) { (error) in
            completion(error == nil)
        }
    }
    
    public func createPost(newPost: Post, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username")
        else {
            completion(false)
            return
        }
        
        let reference = database.document("users/\(username)/posts/\(newPost.id)")
        guard let data = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
    
    public func posts(
        for user: User,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        let reference = database.collection("users")
            .document(user.username)
            .collection("posts")
        reference.getDocuments { (snapshot, error) in
            guard let posts = snapshot?.documents.compactMap({
                Post(with: $0.data())
            }),
                  error == nil else {
                return
            }
            
            completion(.success(posts))
        }
    }
    
    public func findUser(with email: String, completion: @escaping (User?) -> Void) {
        let reference = database.collection("users")
        reference.getDocuments { (snapshot, error) in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            
            let user = users.first(where: { $0.email == email })
            completion(user)
        }
    }
    
    public func findUser(username: String, completion: @escaping (User?) -> Void) {
        let reference = database.collection("users")
        reference.getDocuments { (snapshot, error) in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }), error == nil else {
                completion(nil)
                return
            }
            
            let user = users.first(where: { $0.username == username })
            completion(user)
        }
    }
    
    public func explorePosts(completion: @escaping ([Post]) -> Void) {
        let userRef = database.collection("users")
        userRef.getDocuments { (snapshot, error) in
            guard let users = snapshot?.documents.compactMap({
                User(with: $0.data())
            }),
            error == nil else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var aggregatePosts = [Post]()
            
//            let postRef = userRef.document(users[0].username).collection("posts")
            users.forEach { (user) in
                let username = user.username
                let postRef = self.database.collection("users/\(username)/posts")
                group.enter()
                postRef.getDocuments { (snapshot, error) in
                    
                    defer {
                        group.leave()
                    }
                    
                    guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data( ))}),
                          error == nil else {
                        return
                    }
                    
                    
                    aggregatePosts.append(contentsOf: posts)
                }
            }
            
            group.notify(queue: .main) {
                completion(aggregatePosts)
            }
        }
    }
    
    public func getNotifications(
        completion: @escaping ([IGNotification]) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username")?.lowercased()
        else {
            completion([])
            return
            
        }
        
        let reference = database
            .collection("users")
            .document(username)
            .collection("notifications")
        
        reference.getDocuments { (snapshot, error) in
            guard let notifications = snapshot?.documents.compactMap({
                IGNotification(with: $0.data())
            }),
            error == nil else {
                completion([])
                return
            }
            
            completion(notifications)
        }
    }
    
    public func insertNotification(
        identifier: String,
        data: [String: Any],
        for username: String
    ) {
        let reference = database.collection("users")
            .document(username)
            .collection("notifications")
            .document(identifier)
        
        reference.setData(data)
    }
    
    public func getPost(
        with identifier: String,
        from username: String,
        completion: @escaping (Post?) -> Void
    ) {
        let reference = database.collection("users")
            .document(username)
            .collection("posts")
            .document(identifier)
        reference.getDocument { (snapshot, error) in
            guard let data = snapshot?.data(),
                error == nil else {
                completion(nil)
                return
            }
            
            completion(Post(with: data))
        }
    }
    
    enum RelationshipState {
        case follow
        case unfollow
    }
    
    public func updateRelationship(
        state: RelationshipState,
        for targetUsername: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            completion(false)
            return
        }
        
        let currentFollowing = database.collection("users")
            .document(currentUsername)
            .collection("following")
        
        let targetUserFollowers = database.collection("users")
            .document(targetUsername)
            .collection("followers")

        
        switch state {
        case .unfollow:
            // Remove follower from currentUser following list
            currentFollowing.document(targetUsername).delete()
            // Remove currentUser from targetUser follower list
            targetUserFollowers.document(currentUsername).delete()
            
            completion(true)
        
        case .follow:
            // Add follower from currentUser following list
            currentFollowing.document(targetUsername).setData(["valid": "1"])
            // Add currentUser from targetUser follower list
            targetUserFollowers.document(currentUsername).setData(["valid": "1"])
            completion(true)
        
        }
    }
}

