//
//  HomeReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import Utils
import ComposableArchitecture

public struct HomeReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var presentCreateView = false
        var presentListView = false
    }
    
    public enum Action: BindableAction {
        case presentCrateView
        case presentListView
        case binding(BindingAction<State>)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .presentCrateView:
                state.presentCreateView.toggle()
                return .none
            case .presentListView:
                state.presentListView.toggle()
                return .none
            }
        }
    }
}
