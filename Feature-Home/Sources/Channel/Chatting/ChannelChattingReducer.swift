//
//  ChannelChattingReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/24/24.
//

import Foundation
import Database
import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
public struct ChannelChattingReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        init(selectedChannel: Shared<StudyGroupChannel?>, chatList: Shared<[ChannelChatting]>) {
            _selectedChannel = selectedChannel
            _chatList = chatList
        }
        
        @Shared var selectedChannel: StudyGroupChannel?
        @Shared var chatList: [ChannelChatting]
        
        var text: String = ""
        var isEnabled = false
        var isFocused = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case sendMyChat // 채팅보내기
        case sendedChat // 내 채팅 보낸 이후
        case connectSocket // 소켓 연결 등록
        case disconnectSocket // 소켓 연결 해제
        case appendChat(ChannelChatting) // 실시간으로 새로 받아온 채팅 반영
        case saveChatList(String) // 채팅 리스트 저장
        case setFocus(Bool) // FocusState 반영
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .setFocus(let isFocused):
                state.isFocused = isFocused
                return .none
                  
            case .connectSocket:
                guard let channel = state.selectedChannel else { return .none }
                SocketService.shared.establishConnection(router: .channel(id: channel.channelId))
                return .none
                
            case .appendChat(let chat):
                state.chatList.append(chat)
                guard let channel = state.selectedChannel else { return .none }
                return .send(.saveChatList(channel.channelId))
                
            case .disconnectSocket:
                SocketService.shared.disconnectSocket()
                return .none
                
            case .saveChatList(let id):
                let chatList = state.chatList
                ChatRepository.shared.saveChannelChatRoom(roomId: id, list: chatList)
                return .none
                
            case .sendMyChat:
                return .run { [id = UserDefaultsManager.shared.recentGroupId, channel = state.selectedChannel, content = state.text] send in
                    guard let channel else { return }
                    do {
                        let _ = try await NetworkService.shared.postMyChat(workspaceId: id, channelId: channel.channelId, content: content, files: [])
                        await send(.sendedChat)
                    } catch {
                        print(error)
                    }
                }
                
            case .sendedChat:
                state.text = ""
                guard let channel = state.selectedChannel else { return .none }
                return .send(.saveChatList(channel.channelId))
            }
        }
    }
}
