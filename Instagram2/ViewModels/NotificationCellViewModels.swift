//
//  NotificationCellViewModels.swift
//  Instagram2
//
//  Created by Roy Park on 4/21/21.
//

import Foundation

struct LikeNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let postURL: URL
}

struct FollowNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let isCurrentUserFollowing: Bool
}

struct CommentNotificationCellViewModel {
    let username: String
    let profilePictureURL: URL
    let postURL: URL

}
