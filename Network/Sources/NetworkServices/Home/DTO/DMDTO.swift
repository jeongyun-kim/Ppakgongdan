//
//  DMDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/4/24.
//

import Foundation

public struct DmDTO: Decodable {
    public let roomId: String
    public let createdAt: String
    public let user: MemberDTO
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case user
    }
    
    public func toDirectMessage() -> DirectMessage {
        return DirectMessage(roomId: roomId, createdAt: createdAt, user: user)
    }
}
