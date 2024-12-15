//
//  EmptySource.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import NetworkKit
import RealmSwift

public final class ChatRepository {
    public static let shared = ChatRepository()
    private let realm = try! Realm()
    
    private func deleteChatRoom<T: Object>(room: T) {
        do {
            try realm.write {
                realm.delete(room)
            }
        } catch {
            print("delete chat error!")
        }
    }
}

// MARK: Channel
extension ChatRepository {
    private func channelChattingToChatRoom(roomId: String, list: [ChannelChatting]) -> ChannelChatRoom {
        var chats = List<ChannelChat>()
        
        for chatting in list {
            var files: List<String> = List()
            for file in chatting.files {
                files.append(file)
            }
            
            let chatUser = chatting.user
            let user = User(id: chatUser.userId, email: chatUser.email, nickname: chatUser.nickname, profileImage: chatUser.profileImage)
            let chat = ChannelChat(channelId: chatting.chatId, channelName: chatting.channelName, chatId: chatting.chatId, content: chatting.content, createdAt: chatting.createdAt, files: files, user: user)
            chats.append(chat)
        }
        
        let chatRoom = ChannelChatRoom(id: roomId, chats: chats)
        return chatRoom
    }
    
    // MARK: SaveChannelChatRoom
    public func saveChannelChatRoom(roomId: String, list: [ChannelChatting]) {
        do {
            // 이미 존재한다면 삭제부터
            if let existChannelChatRoom = readChannelChatRoom(roomId: roomId) {
                deleteChatRoom(room: existChannelChatRoom)
            }
            
            try realm.write {
                let channelChatRoom = channelChattingToChatRoom(roomId: roomId, list: list)
                realm.add(channelChatRoom)
            }
        } catch {
            print("save channel chat error!")
        }
    }
    
    // MARK: GetChannelLastReadDate
    public func getChannelLastReadDate(channelId: String, createdAt: String) -> String {
        guard let chatRoom = readChannelChatRoom(roomId: channelId) else { return createdAt }
        return chatRoom.lastReadDate
    }
    
    // MARK: ReadChannelChatRoom
    public func readChannelChatRoom(roomId: String) -> ChannelChatRoom? {
        return realm.object(ofType: ChannelChatRoom.self, forPrimaryKey: roomId)
    }
}

// MARK: Dm
extension ChatRepository {
    // MARK: ChannelChattingToChatRoom
    private func dmChattingToChatRoom(roomId: String, list: [DmChatting]) -> DmChatRoom {
        var chats = List<DmChat>()
        
        for chatting in list {
            let chatUser = chatting.user
            let user = User(id: chatUser.userId, email: chatUser.email, nickname: chatUser.nickname, profileImage: chatUser.profileImage)
            let dmChat = DmChat(roomId: chatting.roomId, dmId: chatting.dmId, content: chatting.content, createdAt: chatting.createdAt, user: user)
            chats.append(dmChat)
        }
        
        let dmChatRoom = DmChatRoom(roomId: roomId, chats: chats)
        return dmChatRoom
    }
    
    // MARK: SaveDmChatRoom
    public func saveDmChatRoom(roomId: String, list: [DmChatting]) {
        do {
            if let existDmChatRoom = readDmChatRoom(roomId: roomId) {
                //                deleteDmChatRoom(roomId: roomId)
                deleteChatRoom(room: existDmChatRoom)
            }
            
            try realm.write {
                let dmChatRoom = dmChattingToChatRoom(roomId: roomId, list: list)
                realm.add(dmChatRoom)
            }
        } catch {
            print("save dm chat error!")
        }
    }
    
    // MARK: ReadDmChatRoom
    public func readDmChatRoom(roomId: String) -> DmChatRoom? {
        return realm.object(ofType: DmChatRoom.self, forPrimaryKey: roomId)
        
    }
}
