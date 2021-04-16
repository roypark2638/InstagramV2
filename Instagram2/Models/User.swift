//
//  User.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation

// Codable contains encodable and decodable.
// We added encodable extension to handle User as dictionary for our firebase database
struct User: Codable {
    let username: String
    let email: String
    let profileImage: Data?
}
