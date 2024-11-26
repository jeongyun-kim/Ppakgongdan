//
//  ChannelChattingReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/24/24.
//

import Foundation
import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
struct ChannelChattingReducer {
    @ObservableState
    struct State: Equatable {
        init(selectedChannel: Shared<StudyGroupChannel?>, workspaceId: String?) {
            _selectedChannel = selectedChannel
            self.workspaceId = workspaceId
        }
        
        @Shared var selectedChannel: StudyGroupChannel?
        var workspaceId: String?
        var text: String = ""
        var isEnabled = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case getChannelChats // 현 채널의 채팅 목록 받아오기
        case sendMyChat // 채팅보내기
        case sendedChat // 내 채팅 보낸 이후
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .getChannelChats:
                return .run { [id = state.workspaceId, channel = state.selectedChannel] send in
                    guard let id, let channel else { return }
                    do {
                        let result = try await NetworkService.shared.getChannelChats(workspaceId: id, channelId: channel.channelId, after: channel.createdAt)
                        print(result)
                    } catch {
                        print(error)
                    }
                }
                
            case .sendMyChat:
                return .run { [id = state.workspaceId, channel = state.selectedChannel, content = state.text] send in
                    guard let id, let channel else { return }
                    do {
                        let result = try await NetworkService.shared.postMyChat(workspaceId: id, channelId: channel.channelId, content: content, files: [])
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
