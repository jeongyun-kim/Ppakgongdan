//
//  Dm.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/20/24.
//

import Foundation

public struct DirectMessage: Equatable {
    public init(roomId: String, createdAt: String, user: MemberDTO) {
        self.roomId = roomId
        self.createdAt = createdAt
        self.user = user.toStudyGroupMember()
        self.unreadCount = 0
    }
    
    public let roomId: String
    public let createdAt: String
    public let user: StudyGroupMember
    public var unreadCount: Int
}
