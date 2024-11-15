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
        public init(group: Shared<StudyGroup?>, groupCount: Shared<Int>) {
            _group = group
            _groupCount = groupCount
        }
        
        @Shared var group: StudyGroup?
        @Shared var groupCount: Int
        var isPresentCreateView = false
        var isPresentingAlert = false
        var isPresentingSideMenu = false
        var studyGroupInfos: StudyGroupDetail? = nil
        var studyGroupChannels: [StudyGroupChannel] = []
        var studyGroupMemebers: [StudyGroupMember] = []
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case presentCreateView // 그룹 생성뷰 띄울지 말지
        case toggleReloginAlert // 토큰 갱신 알림
        case viewDidDisappear // 뷰 사라짐
        case presentSideMenu // 사이드메뉴 열기
        case dismissSideMenu // 사이드메뉴 닫기
        case getWorkspaceDetail // 상세정보 받아오기
        case changedWorkspaceDetail(WorkspaceDetail) // 그룹 선택할 때마다 상세정보 받아오기
        case setStudyGroupInfos(StudyGroupDetail) // 스터디그룹 정보
        case setStudyGroupChannels([StudyGroupChannel]) // 스터디그룹 채널 정보
        case setStudyGroupMembers([StudyGroupMember]) // 스터디그룹 멤버 정보
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .presentCreateView:
                state.isPresentCreateView.toggle()
                return .none
                
            case .toggleReloginAlert:
                state.isPresentingAlert.toggle()
                return .none
                
            case .viewDidDisappear:
                guard let group = state.group else { return .none }
                UserDefaultsManager.shared.recentGroupId = group.groupId
                return .none
                
            case .presentSideMenu:
                state.isPresentingSideMenu = true
                return .none
                
            case .dismissSideMenu:
                state.isPresentingSideMenu = false
                return .none
                
            case .getWorkspaceDetail:
                return .run { [group = state.group] send in
                    do {
                        guard let group else { return }
                        let result = try await NetworkService.shared.getWorkspaceDetail(workspaceId: group.groupId)
                        await send(.changedWorkspaceDetail(result))
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            case .changedWorkspaceDetail(let detail):
                return .merge (
                        .send(.setStudyGroupInfos(detail.toStudyGroupDetail())),
                        .send(.setStudyGroupChannels(detail.channels.map { $0.toStudyGroupChannel() })),
                        .send(.setStudyGroupMembers(detail.workspaceMembers.map { $0.toStudyGroupMember() }))
                    )
                
            case .setStudyGroupInfos(let infos):
                state.studyGroupInfos = infos
                return .none
                
            case .setStudyGroupChannels(let channels):
                state.studyGroupChannels = channels
                print(state.studyGroupChannels)
                return .none
                
            case .setStudyGroupMembers(let members):
                state.studyGroupMemebers = members
                print(state.studyGroupMemebers)
                return .none
            }
        }
    }
}

