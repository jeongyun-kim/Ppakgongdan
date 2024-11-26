//
//  ChannelChattingDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

public struct ChannelChattingDTO: Decodable {
    let channelId: String
    let channelName: String
    let chatId: String
    let content: String
    let createdAt: String
    let files: [String]
    let user: Member
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
    
    public func toChannelChatting() -> ChannelChatting {
        return ChannelChatting(channelId: self.channelId,
                               channelName: self.channelName,
                               chatId: self.chatId,
                               content: self.content,
                               createdAt: self.content,
                               files: self.files,
                               user: self.user.toStudyGroupMember())
    }
}
