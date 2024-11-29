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
struct ChannelChattingReducer {
    @ObservableState
    struct State: Equatable {
        init(selectedChannel: Shared<StudyGroupChannel?>, chatList: Shared<[ChannelChatting]>, workspaceId: String?) {
            _selectedChannel = selectedChannel
            _chatList = chatList
            self.workspaceId = workspaceId
        }
        
        @Shared var selectedChannel: StudyGroupChannel?
        @Shared var chatList: [ChannelChatting]
        var workspaceId: String?
        var text: String = ""
        var isEnabled = false
        var isFocused = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case sendMyChat // 채팅보내기
        case sendedChat // 내 채팅 보낸 이후
        case connectSocket // 소켓 연결 등록
        case disconnectSocket // 소켓 연결 해제
        case appendChat(ChannelChatting) // 실시간으로 새로 받아온 채팅 반영
        case saveChatList
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .connectSocket:
                return .run { [channel = state.selectedChannel] send in
                    guard let channel else { return }
                    let continuation = await withCheckedContinuation { continuation in
                        SocketService.shared.estabilishConnection(channelId: channel.channelId) { data in
                            continuation.resume(returning: data)
                        }
                    }
                    await send(.appendChat(continuation.toChannelChatting()))
                }
                
            case .appendChat(let chat):
                print(state.chatList)
                state.chatList.append(chat)
                return .none
                
            case .disconnectSocket:
                SocketService.shared.disconnectSocket()
                return .send(.saveChatList)
                
            case .saveChatList:
                guard let channel = state.selectedChannel else { return .none }
                let chatList = state.chatList
                ChatRepository.shared.saveChatRoom(roomId: channel.channelId, list: chatList)
                return .none
                
            case .sendMyChat:
                return .run { [id = state.workspaceId, channel = state.selectedChannel, content = state.text] send in
                    guard let id, let channel else { return }
                    do {
                        let _ = try await NetworkService.shared.postMyChat(workspaceId: id, channelId: channel.channelId, content: content, files: [])
                        await send(.sendedChat)
                    } catch {
                        print(error)
                    }
                }
                
            case .sendedChat:
                state.text = ""
                return .none
            }
        }
    }
}
