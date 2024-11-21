//
//  Dm.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/20/24.
//

import Foundation

public struct DM: Decodable {
    public let roomId: String
    public let createdAt: String
    public let user: Member
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case user
    }
    
    public func toDirectMessage() -> DirectMessage {
        return DirectMessage(roomId: roomId, createdAt: createdAt, user: user)
    }
}

public struct DirectMessage: Equatable {
    public init(roomId: String, createdAt: String, user: Member) {
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
