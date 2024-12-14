//
//  Dm.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/10/24.
//

import Foundation

public struct DmChatting: Equatable {
    public init(dmId: String, roomId: String, content: String, createdAt: String, files: [String], user: StudyGroupMember) {
        self.dmId = dmId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
        self.unreadCount = 0
    }
    
    public let dmId: String
    public let roomId: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let user: StudyGroupMember
    public var unreadCount: Int
}
