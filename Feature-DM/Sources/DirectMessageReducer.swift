//
//  DirectMessageReducer.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/9/24.
//

import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
public struct DirectMessageReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
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
