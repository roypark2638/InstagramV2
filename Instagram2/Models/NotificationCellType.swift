//
//  NotificationCellType.swift
//  Instagram2
//
//  Created by Roy Park on 4/21/21.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
