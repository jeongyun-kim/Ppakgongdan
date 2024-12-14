//
//  DirectMessageChattingReducer.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/10/24.
//

import Utils
import NetworkKit
import ComposableArchitecture

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
        case connectSocket
        case disconnectSocket
        case appendChat(DmChatting)
        case sendMyChat
        case sendedChat
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
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
