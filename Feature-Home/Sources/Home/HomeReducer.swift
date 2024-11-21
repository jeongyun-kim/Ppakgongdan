//
//  HomeReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import NetworkKit
import Utils
import ComposableArchitecture
import Foundation

public struct HomeReducer: Reducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(group: Shared<StudyGroup?>, groupCount: Shared<Int>) {
            _group = group
            _groupCount = groupCount
            _isPresentingSideMenu = Shared(false)
        }
        
        @Shared var isPresentingSideMenu: Bool
        @Shared var group: StudyGroup?
        @Shared var groupCount: Int
        var isPresentCreateView = false
        var isPresentingAlert = false
        var isPresentingChannelActionView = false
        var isPresentingAddChannelView = false
        var isExpandedChannels = false
        var isExpandedDms = false
        var studyGroupInfos: StudyGroupDetail? = nil
        var studyGroupChannels: [StudyGroupChannel] = []
        var studyGroupMemebers: [StudyGroupMember] = []
        var dmList: [DirectMessage] = []
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case presentCreateView // 그룹 생성뷰 띄울지 말지
        case toggleReloginAlert // 토큰 갱신 알림
        case viewDidDisappear // 뷰 사라짐
        case presentAddChannelView
        case presentChannelActionView
        case presentSideMenu // 사이드메뉴 열기
        case dismissSideMenu // 사이드메뉴 닫기
        case toggleExpandedChannels // 채널 열고닫기
        case toggleExpandedDms // DM 열고 닫기
        case getWorkspaceDetail // 상세정보 받아오기
        case changedWorkspaceDetail(WorkspaceDetail) // 그룹 선택할 때마다 상세정보 받아오기
        case setStudyGroupInfos(StudyGroupDetail) // 스터디그룹 정보
        case setStudyGroupChannels([StudyGroupChannel]) // 스터디그룹 채널 정보
        case setStudyGroupMembers([StudyGroupMember]) // 스터디그룹 멤버 정보
        case getUnreadChannelsCount([Channel]) // 채널의 안 읽은 메시지 개수 가져오기
        case getDmList // DM 조회하기
        case getUnreadDmCounts([DM]) // 안 읽은 DM 개수 조회
        case setDmList([DirectMessage]) // 조회한 DM 내역 보여주기
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
                
            case .presentAddChannelView:
                state.isPresentingAddChannelView.toggle()
                return .none
                
            case .presentChannelActionView:
                state.isPresentingChannelActionView.toggle()
                return .none
                
            case .presentSideMenu:
                state.isPresentingSideMenu = true
                return .none
                
            case .dismissSideMenu:
                state.isPresentingSideMenu = false
                return .none
                
            case .toggleExpandedChannels:
                // 🧐 사이드메뉴는 건드리지도 않았는데 왜 true로 되어서 나오는가..
                state.isExpandedChannels.toggle()
                return .none
                
            case .toggleExpandedDms:
                state.isExpandedDms.toggle()
                return .none
                
            case .getWorkspaceDetail: // 선택한 스터디그룹의 상세정보 조회
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
                
            case .changedWorkspaceDetail(let detail): // 선택한 스터디그룹 변경 시마다 호출
                return .merge (
                        .send(.setStudyGroupInfos(detail.toStudyGroupDetail())),
                        .send(.getUnreadChannelsCount(detail.channels)),
                        .send(.setStudyGroupMembers(detail.workspaceMembers.map { $0.toStudyGroupMember() })),
                        .send(.getDmList)
                    )
                
            case .getUnreadChannelsCount(let channels): // 안 읽은 채널 개수 조회
                return .run { [info = state.studyGroupInfos] send in
                    guard let info else { return }
                    var studyGroupChannels: [StudyGroupChannel] = []
                    
                    for channel in channels {
                        do {
                            let result = try await NetworkService.shared.getUnreadChannels(workspaceId: info.workspaceId, channelId: channel.channelId, after: channel.createdAt)
                            var studyGroupChannel = channel.toStudyGroupChannel()
                            studyGroupChannel.unreadCount = result.count
                            studyGroupChannels.append(studyGroupChannel)
                        } catch {
                            print(error)
                        }
                    }
                    
                    await send(.setStudyGroupChannels(studyGroupChannels))
                }
                
            case .setStudyGroupInfos(let infos): // 스터디그룹 정보 세팅
                state.studyGroupInfos = infos
                return .none
                
            case .setStudyGroupChannels(let channels): // 채널 세팅
                state.studyGroupChannels = channels
                return .none
                
            case .setStudyGroupMembers(let members): // 멤버 세팅
                state.studyGroupMemebers = members
                return .none
                
            case .getDmList: // DM 조회하기
                return .run { [info = state.studyGroupInfos] send in
                    guard let info else { return }
                    do {
                        let result = try await NetworkService.shared.getDmList(workspaceId: info.workspaceId)
                        await send(.getUnreadDmCounts(result))
                    } catch {
                        print(error)
                    }
                }
            
            case .getUnreadDmCounts(let dms): // 안 읽은 메시지수 조회
                return .run { [info = state.studyGroupInfos] send in
                    guard let info else { return }
                    var directMessages: [DirectMessage] = []

                    for dm in dms {
                        do {
                            let result = try await NetworkService.shared.getUnreadDms(workspaceId: info.workspaceId, roomlId: dm.roomId, after: dm.createdAt)
                            var directMessage = DirectMessage(roomId: dm.roomId, createdAt: dm.createdAt, user: dm.user)
                            directMessage.unreadCount = result.count
                            directMessages.append(directMessage)
                        } catch {
                            print(error)
                        }
                    }
                    
                    await send(.setDmList(directMessages))
                }
                
            case .setDmList(let dms): // dmList 세팅
                state.dmList = dms
                return .none
            }
        }
    }
}

