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
    
    // MARK: SaveChatRoom
    public func saveChatRoom(roomId: String, list: [ChannelChatting]) {
        do {
            // 이미 존재한다면 삭제부터
            if let _ = readChatRoom(roomId: roomId) {
                deleteChatRoom(roomId: roomId)
            }
            
            try realm.write {
                let chatRoom = channelChattingToChatRoom(roomId: roomId, list: list)
                realm.add(chatRoom)
            }
        } catch {
            print("save chat error!")
        }
    }

    // MARK: GetChannelLastReadDate
    public func getChannelLastReadDate(channelId: String, createdAt: String) -> String {
        guard let chatRoom = readChatRoom(roomId: channelId) else { return createdAt }
        return chatRoom.readDate
    }
    
    // MARK: ReadChatRoom
    public func readChatRoom(roomId: String) -> ChatRoom? {
        return realm.object(ofType: ChatRoom.self, forPrimaryKey: roomId)
    }
    
    // MARK: DeleteChatRoom
    private func deleteChatRoom(roomId: String) {
        do {
            try realm.write {
                guard let existChatRoom = readChatRoom(roomId: roomId) else { return }
                realm.delete(existChatRoom)
            }
        } catch {
            print("delete chat error!")
        }
    }
}

extension ChatRepository {
    // MARK: ChannelChattingToChatRoom
    private func channelChattingToChatRoom(roomId: String, list: [ChannelChatting]) -> ChatRoom {
        var chats = List<Chat>()
        
        for chatting in list {
            var files: List<String> = List()
            for file in chatting.files {
                files.append(file)
            }
            
            let chatUser = chatting.user
            let user = User(id: chatUser.userId, email: chatUser.email, nickname: chatUser.nickname, profileImage: chatUser.profileImage)
            let chat = Chat(channelId: chatting.chatId, channelName: chatting.channelName, chatId: chatting.chatId, content: chatting.content, createdAt: chatting.createdAt, files: files, user: user)
            chats.append(chat)
        }
        
        let chatRoom = ChatRoom(id: roomId, chats: chats)
        print(chatRoom)
        return chatRoom
    }
}
