//
//  DmChatRoom.swift
//  Database
//
//  Created by 김정윤 on 12/14/24.
//

import Foundation
import RealmSwift
import UI

public class DmChatRoom: Object, ObjectKeyIdentifiable {
    convenience init(roomId: String, chats: List<DmChat>) {
        self.init()
        self.roomId = roomId
        self.chats = chats
        self.lastReadDate = Date().toFormattedString()
    }
    
    @Persisted(primaryKey: true) public var roomId: String
    @Persisted public var chats: List<DmChat>
    @Persisted public var lastReadDate: String
}

