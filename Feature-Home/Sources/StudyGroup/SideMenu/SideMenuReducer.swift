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
        public init(isPresenting: Shared<Bool>, group: Shared<StudyGroup?>, groupCount: Shared<Int>) {
            _isPresentingSideMenu = isPresenting
            _group = group
            _groupCount = groupCount
            
            alertReducerState = .init(group: _group, groupCount: _groupCount)
            createGroupReducerState = .init(group: _group, groupCount: _groupCount)
        }
        
        @Shared var groupCount: Int  // 현재 사용자의 그룹 개수
        @Shared var isPresentingSideMenu: Bool // 사이드메뉴 표출 여부
        @Shared var group: StudyGroup?  // 현재 선택중인 그룹
        var isPresentingCreateView = false // 생성뷰 표출 여부
        var isPresentingReloginAlert = false // 재로그인 알림 표출 여부
        var studyGroupList: [StudyGroup] = [] // 스터디그룹 목록
        var isPresentingSettingActionSheet = false // 스터디그룹 설정 액션시트 표출 여부
        var isPresentingSettingAlert = false // 스터디그룹 나가기 같은 설정뷰 표출 여부
        
        var alertReducerState: SettingAlertReducer.State
        var createGroupReducerState: CreateStudyGroupReducer.State
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alertReducerAction(SettingAlertReducer.Action)
        case createGroupReducerAction(CreateStudyGroupReducer.Action)
        case toggleReloginAlert
        case toggleCreateView
        case toggleSettingActionSheet
        case dismissSideMenu
        case completed([StudyGroup])
        case getStudyGroups
        case changedStudyGroup(StudyGroup)
        case deleteStudyGroup(id: String)
        case toggleSettingAlert
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.alertReducerState, action: \.alertReducerAction) {
            SettingAlertReducer()
        }
        
        Scope(state: \.createGroupReducerState, action: \.createGroupReducerAction) {
            CreateStudyGroupReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .alertReducerAction:
                return .none
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
                
            case .toggleCreateView:
                state.isPresentingCreateView.toggle()
                return .none
                
            case .toggleSettingActionSheet:
                state.isPresentingSettingActionSheet.toggle()
                return .none
                
            case .dismissSideMenu:
                state.isPresentingSideMenu.toggle()
                return .none
                
            case .toggleSettingAlert:
                state.isPresentingSettingAlert.toggle()
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
                
            case .completed(let groups):
                state.studyGroupList = groups
                state.groupCount = groups.count
                return .none
                
            case .changedStudyGroup(let group):
                state.group = group
                UserDefaultsManager.shared.recentGroupId = group.groupId
                return .none
                
            case .deleteStudyGroup(let id):
                return .run { send in
                    do {
                        let _ = try await NetworkService.shared.deleteWorkspace(groupId: id)
                        // 삭제할 때, 최근 접속 그룹아이디가 해당 그룹이라면 최근 접속 그룹도 비워주기 
                        if UserDefaultsManager.shared.recentGroupId == id {
                            UserDefaultsManager.shared.recentGroupId = ""
                        }
                        UserDefaultsManager.shared.groupCount -= 1
                        await send(.getStudyGroups)
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            default:
                return .none
            }
        }
    }
    
    
}
