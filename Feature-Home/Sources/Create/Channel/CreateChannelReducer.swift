//
//  CreateChannelReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/21/24.
//

import Utils
import NetworkKit
import ComposableArchitecture

public struct CreateChannelReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var channelName = ""
        var channelDesc = ""
        var isDisabled = true
        var isCompleted = false
    }
    
    public enum Actoin: BindableAction {
        case binding(BindingAction<State>)
        case validateChannelName // 채널명 조건 확인 
        case createNewChannel // 새로운 채널 생성
    }
    
    public var body: some Reducer<State, Actoin> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .validateChannelName:
                state.isDisabled = state.channelName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                return .none
                
            case .createNewChannel:
                print("new!")
                return .none
            }
        }
    }
}

