//
//  DmChat.swift
//  Database
//
//  Created by 김정윤 on 12/14/24.
//

import Foundation
import RealmSwift
import NetworkKit

public class DmChat: Object, ObjectKeyIdentifiable {
    public convenience init(roomId: String, dmId: String, content: String, createdAt: String, user: User) {
        self.init()
        self.roomId = roomId
        self.dmId = dmId
        self.content = content
        self.createdAt = createdAt
        self.user = user
    }
    
    @Persisted public var roomId: String
    @Persisted public var dmId: String
    @Persisted public var content: String
    @Persisted public var createdAt: String
    @Persisted public var user: User?
    
    public func toDmChatting() -> DmChatting? {
        if let user = self.user {
            return DmChatting(dmId: self.dmId,
                              roomId: self.roomId,
                              content: self.content,
                              createdAt: self.createdAt,
                              files: [],
                              user: user.toStudyGroupMember())
        } else {
            return nil
        }
    }
}
