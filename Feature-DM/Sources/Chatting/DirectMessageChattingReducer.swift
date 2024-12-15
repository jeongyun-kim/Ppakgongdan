//
//  DirectMessageChattingReducer.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/10/24.
//

import Foundation
import Utils
import NetworkKit
import ComposableArchitecture
import Database

@Reducer
public struct DirectMessageChattingReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        var chatRoomInfo: DirectMessage? = nil
        var chatList: [DmChatting] = []
        var text: String = ""
        var isFocused = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setFocus(Bool)
        case connectSocket // 소켓 연결
        case disconnectSocket // 소켓 끊기
        case saveChatRoom // 채팅방 저장 
        case appendChat(DmChatting) // 채팅 보내고 데이터 추가
        case sendMyChat // 채팅 보내기
        case sendedChat // 채팅 보낸 후
        case getAllChatsFromDB // DB로부터 채팅 내역 가져오기
        case getAllChatsFromServer(after: String) // 서버로부터 채팅 내역 가져오기
        case setAllChats([DmChatting]) // 서버 내 채팅 반영
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .setFocus(let focus):
                state.isFocused = focus
                return .none
                
            case .connectSocket:
                guard let info = state.chatRoomInfo else { return .none }
                SocketService.shared.establishConnection(router: .dm(id: info.roomId))
                return .none
                
            case .appendChat(let chat):
                state.chatList.append(chat)
                return .none
                
            case .disconnectSocket:
                SocketService.shared.disconnectSocket()
                return .send(.saveChatRoom)
                
            case .saveChatRoom:
                guard let info = state.chatRoomInfo else { return .none }
                ChatRepository.shared.saveDmChatRoom(roomId: info.roomId, list: state.chatList)
                return .none
                
            case .getAllChatsFromDB:
                guard let info = state.chatRoomInfo else { return .none }
                guard let dmChatRoom = ChatRepository.shared.readDmChatRoom(roomId: info.roomId) else {
                    return .send(.getAllChatsFromServer(after: info.createdAt))
                }
                let chatList = Array(dmChatRoom.chats).compactMap { $0.toDmChatting() }
                state.chatList = chatList
                return .send(.getAllChatsFromServer(after: dmChatRoom.lastReadDate))
                
            case .getAllChatsFromServer(let after):
                return .run { [id = UserDefaultsManager.shared.recentGroupId, info = state.chatRoomInfo] send in
                    guard let info else { return }
                    do {
                        let result = try await NetworkService.shared.getDmChattings(workspaceId: id, roomId: info.roomId, after: after)
                        await send(.setAllChats(result.map { $0.toDmChatting() }))
                    } catch {
                        print(error)
                    }
                }
                
            case .setAllChats(let chats):
                state.chatList.append(contentsOf: chats)
                return .send(.connectSocket)
                
            case .sendMyChat:
                return .run { [info = state.chatRoomInfo, id = UserDefaultsManager.shared.recentGroupId, message = state.text] send in
                    guard let info else { return }
                    do {
                        let _ = try await NetworkService.shared.sendDmChat(workspaceId: id, roomId: info.roomId, message: message)
                        await send(.sendedChat)
                    } catch {
                        print(error)
                    }
                }
                
            case .sendedChat:
                state.text = ""
                return .none
                
            default:
                return .none
            }
        }
    }
}
