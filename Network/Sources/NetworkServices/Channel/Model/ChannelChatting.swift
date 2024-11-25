//
//  ChannelChatting.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

public struct ChannelChatting: Decodable {
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
}
