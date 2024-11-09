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
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(group: StudyGroup? = nil) {
            _group = Shared(group)
        }
        
        var isPresentCreateView = false
        var isPresentListView = false
        var isPresentingAlert = false
        @Shared var group: StudyGroup?
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case presentCrateView // 그룹 생성뷰 띄울지 말지
        case presentListView // 그룹 리스트뷰 표출 여부
        case showReloginAlert // 토큰 갱신 알림
        case viewDidDisappear // 뷰 사라짐
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .presentCrateView:
                state.isPresentCreateView.toggle()
                return .none
                
            case .presentListView:
                state.isPresentListView.toggle()
                return .none
                
            case .showReloginAlert:
                state.isPresentingAlert.toggle()
                return .none
                
            case .viewDidDisappear:
                guard let group = state.group else { return .none }
                UserDefaultsManager.shared.recentGroupId = group.groupId
                return .none
            }
        }
    }
}

