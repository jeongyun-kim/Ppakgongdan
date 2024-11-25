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
        case writeMessage
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .writeMessage:
                state.isEnabled = !state.text.isEmpty
                return .none
            }
        }
    }
}
