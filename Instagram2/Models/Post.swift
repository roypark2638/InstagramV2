//
//  Post.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation

struct Post: Codable {
    // id will point to the storage reference where the photo is
    let id: String
    let caption: String?
    let postedDate: String
    let postURLString: String
    var likers: [String]
    
    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        
        return "\(username)/posts/\(id).png"
    }
}
