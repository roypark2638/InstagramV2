//
//  NotificationCellViewModels.swift
//  Instagram2
//
//  Created by Roy Park on 4/21/21.
//

import Foundation

struct LikeNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureURL: URL
    let postURL: URL
}

struct FollowNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureURL: URL
    let isCurrentUserFollowing: Bool
}

struct CommentNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureURL: URL
    let postURL: URL

}
