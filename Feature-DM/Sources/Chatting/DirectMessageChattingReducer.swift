//
//  DirectMessageChattingReducer.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/10/24.
//

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
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case connectSocket // 소켓 연결 
        case disconnectSocket // 소켓 끊기
        case saveChatRoom
        case appendChat(DmChatting) // 채팅 보내고 데이터 추가
        case sendMyChat // 채팅 보내기
        case sendedChat // 채팅 보낸 후
        case getAllChats // 서버/DB로부터 채팅 받아오기
        case setAllChats([DmChatting]) // 서버 내 채팅 반영
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .connectSocket:
                guard let info = state.chatRoomInfo else { return .none }
                SocketService.shared.establishConnection(router: .dm(id: info.roomId))
                return .send(.getAllChats)
                
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
                
            case .getAllChats:
                return .run { [id = UserDefaultsManager.shared.recentGroupId, info = state.chatRoomInfo] send in
                    guard let info else { return }
                    let after = ChatRepository.shared.getDmLastReadDate(roomId: info.roomId, createdAt: info.createdAt)
                    do {
                        let result = try await NetworkService.shared.getDmChattings(workspaceId: id, roomId: info.roomId, after: after)
                        await send(.setAllChats(result.map { $0.toDmChatting() }))
                    } catch {
                        print(error)
                    }
                }
                
            case .setAllChats(let chats):
                state.chatList = chats
                return .none
                
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
