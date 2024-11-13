//
//  SideMenuReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/12/24.
//


import UI
import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
public struct SideMenuReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(isPresenting: Bool, selectedGroup: Shared<StudyGroup?>) {
            _isPresentingSideMenu = Shared(isPresenting)
            _group = selectedGroup
        }
        
        @Shared var isPresentingSideMenu: Bool
        @Shared var group: StudyGroup?
        var isPresentingCreateView = false
        var isPresentingReloginAlert = false
        var studyGroupList = Array<StudyGroup>()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case toggleReloginAlert
        case toggleCreateView
        case dismissSideMenu
        case completed([StudyGroup])
        case getStudyGroups
        case changedStudyGroup(StudyGroup)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
                
            case .toggleCreateView:
                state.isPresentingCreateView.toggle()
                return .none
                
            case .dismissSideMenu:
                state.isPresentingSideMenu.toggle()
                return .none
                
            case .completed(let groups):
                // 🧐 왜 뷰에 반영이 안되나
                state.studyGroupList = groups
                return .none
                
            case .getStudyGroups:
                return .run { send in
                    do {
                        let result = try await NetworkService.shared.getMyWorkspaces()
                        UserDefaultsManager.shared.groupCount = result.count
                        let groups = result.map { $0.toStudyGroup() }
                        await send(.completed(groups))
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            case .changedStudyGroup(let group):
                state.group = group
                UserDefaultsManager.shared.recentGroupId = group.groupId
                // state.isPresentingSideMenu.toggle() <- 🧐 이건 왜 안먹는가
                return .none
            }
        }
    }


}
