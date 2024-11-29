//
//  ChatRoom.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import RealmSwift

public class ChatRoom: Object, ObjectKeyIdentifiable {
    convenience init(id: String, chats: List<Chat>) {
        self.init()
        self.id = id
        self.chats = chats
        self.readDate = Date().toFormattedString()
    }
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var chats: List<Chat>
    @Persisted public var readDate: String
}
