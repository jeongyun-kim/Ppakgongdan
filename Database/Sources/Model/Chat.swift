//
//  Chat.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import RealmSwift

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
    
    @Persisted(primaryKey: true) public var channelId: String
    @Persisted public var channelName: String
    @Persisted public var chatId: String
    @Persisted public var content: String
    @Persisted public var createdAt: String
    @Persisted public var files: List<String>
    @Persisted public var user: User
}
