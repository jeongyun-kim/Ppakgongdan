//
//  Dm.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/10/24.
//

import Foundation

public struct DmChatting: Equatable {
    public init(dmId: String, roomId: String, content: String, createdAt: String, files: [String], user: MemberDTO) {
        self.dmId = dmId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user.toStudyGroupMember()
    }
    
    public let dmId: String
    public let roomId: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let user: StudyGroupMember
    
    enum CodingKeys: String, CodingKey {
        case dmId = "dm_id"
        case roomId = "room_id"
        case content
        case createdAt
        case files
        case user
    }
}
