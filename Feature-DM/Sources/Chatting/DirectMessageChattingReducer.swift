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
//        var roomId: String
        var chatList: [DmChatting] = []
        var text: String = ""
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case connectSocket
        case disconnectSocket
        case appendChat(DmChatting)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
