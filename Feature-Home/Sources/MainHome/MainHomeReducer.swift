//
//  MainHomeReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/13/24.
//

import Utils
import NetworkKit
import ComposableArchitecture
import Feature_Login

@Reducer
public struct MainHomeReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            _group = Shared(nil)
            _groupCount = Shared(UserDefaultsManager.shared.groupCount)
            homeReducerState = .init(group: _group, groupCount: _groupCount)
            onboardingReducerState = .init()
        }
        
        @Shared var group: StudyGroup?
        @Shared var groupCount: Int
        
        var isPresentingReloginAlert: Bool = false
        var isPresentingOnbaording: Bool = false
        
        public var homeReducerState: HomeReducer.State
        var onboardingReducerState: OnboardingReducer.State
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case homeReducerAction(HomeReducer.Action)
        case onboardingReducerAction(OnboardingReducer.Action)
        case toggleOnboarding
        case toggleReloginAlert
        case viewDidDisappear
        case getMyWorkspaces
        case getWorkspace(group: StudyGroup)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.homeReducerState, action: \.homeReducerAction) {
            HomeReducer()
        }
        
        Scope(state: \.onboardingReducerState, action: \.onboardingReducerAction) {
            OnboardingReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .toggleOnboarding:
                state.isPresentingOnbaording.toggle()
                return .none
                
            case .viewDidDisappear:
                guard let group = state.group else { return .none }
                UserDefaultsManager.shared.recentGroupId = group.groupId
                UserDefaultsManager.shared.groupCount = state.groupCount
                return .none
                
            case .getMyWorkspaces:
                return .run { send in
                    do {
                        let result = try await NetworkService.shared.getMyWorkspaces()
                        UserDefaultsManager.shared.groupCount = result.count
                        let recentGroupId = UserDefaultsManager.shared.recentGroupId
                        let groupIds = result.map { $0.workspaceId }
                        
                        guard !groupIds.contains(recentGroupId) else {
                            let data = result.filter { $0.workspaceId == UserDefaultsManager.shared.recentGroupId }[0]
                            let studyGroup = data.toStudyGroup()
                            await send(.getWorkspace(group: studyGroup))
                            return
                        }
                
                        guard let group = result.first else { return }
                        let studyGroup = group.toStudyGroup()
                        await send(.getWorkspace(group: studyGroup))
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
                
            case .getWorkspace(let group):
                UserDefaultsManager.shared.recentGroupId = group.groupId
                state.groupCount = UserDefaultsManager.shared.groupCount
                state.group = group
                state.homeReducerState = HomeReducer.State(group: state.$group, groupCount: state.$groupCount)
                return .none
                
            default:
                return .none
            }
        }
    }
}
