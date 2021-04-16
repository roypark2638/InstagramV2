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
}
