//
//  Chat.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import RealmSwift
import NetworkKit

public class Chat: Object, ObjectKeyIdentifiable {
    convenience init(channelId: String, channelName: String, chatId: String, content: String, createdAt: String, files: List<String>, user: User) {
        self.init()
        self.channelId = channelId
        self.channelName = channelName
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
    
    @Persisted public var channelId: String
    @Persisted public var channelName: String
    @Persisted public var chatId: String
    @Persisted public var content: String
    @Persisted public var createdAt: String
    @Persisted public var files: List<String>
    @Persisted public var user: User?
    
    public func toChannelChatting() -> ChannelChatting? {
        if let user = self.user {
            return ChannelChatting(channelId: self.channelId,
                                   channelName: self.channelName,
                                   chatId: self.chatId,
                                   content: self.content,
                                   createdAt: self.createdAt,
                                   files: Array(self.files),
                                   user: user.toStudyGroupMember())
        } else {
            return nil
        }
    }
}
