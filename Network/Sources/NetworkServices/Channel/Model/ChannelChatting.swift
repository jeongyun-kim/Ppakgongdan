//
//  ChannelChatting.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

public struct ChannelChatting: Equatable {
    public let channelId: String
    public let channelName: String
    public let chatId: String
    public let content: String
    public let createdAt: String
    public let files: [String]
    public let user: StudyGroupMember
    
    public init(channelId: String, channelName: String, chatId: String, content: String, createdAt: String, files: [String], user: StudyGroupMember) {
        self.channelId = channelId
        self.channelName = channelName
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}
