//
//  OnboardingReducer.swift
//  Feature-Login
//
//  Created by 김정윤 on 11/1/24.
//

import ComposableArchitecture

@Reducer
public struct OnboardingReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var isPresenting = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case present
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .present:
                state.isPresenting.toggle()
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
