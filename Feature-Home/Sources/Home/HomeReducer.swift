//
//  HomeReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import NetworkKit
import Utils
import ComposableArchitecture

public struct HomeReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var presentCreateView = false
        var presentListView = false
        var isPresentingAlert = false
        var isEmptyHomeView = true
    }
    
    public enum Action: BindableAction {
        case presentCrateView
        case presentListView
        case toggleAlert
        case getMyStudyGroups
        case changeView(Bool)
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
                
            case .toggleAlert:
                state.isPresentingAlert.toggle()
                return .none
                
            case .changeView(let isEmpty):
                state.isEmptyHomeView = isEmpty
                return .none
                
            case .getMyStudyGroups:
                return .run { send in
                    do {
                        let result = try await NetworkService.shared.getMyWorkspaces()
                        await send(.changeView(result.isEmpty))
                    } catch {
                        guard UserDefaultsManager.shared.isUser else { return }
                        await send(.toggleAlert)
                    }
                }
            }
        }
    }
}
