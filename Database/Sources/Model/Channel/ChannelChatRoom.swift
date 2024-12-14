//
//  ChatRoom.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import RealmSwift
import UI

public class ChannelChatRoom: Object, ObjectKeyIdentifiable {
    convenience init(id: String, chats: List<ChannelChat>) {
        self.init()
        self.id = id
        self.chats = chats
        self.readDate = Date().toFormattedString()
    }
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var chats: List<ChannelChat>
    @Persisted public var readDate: String
}
