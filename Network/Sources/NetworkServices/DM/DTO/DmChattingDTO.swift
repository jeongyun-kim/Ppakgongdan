//
//  DmDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/10/24.
//

import Foundation

public struct DmChattingDTO: Decodable {
    let dmId: String
    let roomId: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: MemberDTO
    
    enum CodingKeys: String, CodingKey {
        case dmId = "dm_id"
        case roomId = "room_id"
        case content
        case createdAt
        case files
        case user
    }
    
    public func toDmChatting() -> DmChatting {
        return DmChatting(dmId: self.dmId,
                          roomId: self.roomId,
                          content: self.content,
                          createdAt: self.createdAt,
                          files: self.files,
                          user: self.user.toStudyGroupMember())
    }
}
