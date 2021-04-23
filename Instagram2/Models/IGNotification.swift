//
//  Notification.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation

struct IGNotification: Codable {
    let identifier: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureURL: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    // These two make sure that we don't have to fetch subsequent fetch for the postURL from firebase storage. It's optional because for the follow notification, we are not going to have post in it
    let postID: String?
    let postURL: String?
    
    
}
