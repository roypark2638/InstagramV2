//
//  ProfileHeaderViewModel.swift
//  Instagram2
//
//  Created by Roy Park on 4/25/21.
//

import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureURL: URL?
    let followerCount: Int
    let followingCount: Int
    let postCount: Int
    let buttonType: ProfileButtonType
    let bio: String
    let username: String
    let name: String?
    
}
