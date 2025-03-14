//
//  HomeReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import Database
import NetworkKit
import Utils
import UI
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
            _isPresentingExploringChannelView = Shared(false)
            _selectedChannel = Shared<StudyGroupChannel?>(nil)
            _channelChatList = Shared([])
            
            sideMenuReducerState = SideMenuReducer.State(isPresenting: _isPresentingSideMenu, group: _group, groupCount: _groupCount)
            exploreChannelReducerState = ExploringChannelReducer.State(isPresentingExploringChannelView: _isPresentingExploringChannelView,
                                                                       group: _group,
                                                                       selectedChannel: _selectedChannel,
                                                                       chatList: _channelChatList)
            channelChattingReducerState = .init(selectedChannel: _selectedChannel,
                                                chatList: _channelChatList)
        }
        
        @Shared var isPresentingSideMenu: Bool
        @Shared var group: StudyGroup?
        @Shared var groupCount: Int
        
        @Shared var isPresentingExploringChannelView: Bool
        @Shared var selectedChannel: StudyGroupChannel?
        @Shared var channelChatList: [ChannelChatting]

        var isPresentCreateView = false
        var isPresentingAlert = false
        var isPresentingChannelActionView = false
        var isPresentingAddChannelView = false
        var isPresentingInviteMemeberView = false

        var isExpandedChannels = false
        var isExpandedDms = false
        
        var studyGroupInfos: StudyGroupDetail? = nil
        var studyGroupChannels: [StudyGroupChannel] = []
        var studyGroupMemebers: [StudyGroupMember] = []
        var dmList: [DirectMessage] = []
        
        var memberEmail = ""
        var isDisabledInviteMember = true
        
        public var sideMenuReducerState: SideMenuReducer.State
        var exploreChannelReducerState: ExploringChannelReducer.State
        var channelChattingReducerState: ChannelChattingReducer.State
        var createChannelReducerState: CreateChannelReducer.State!
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exploreChannelReducerAction(ExploringChannelReducer.Action)
        case sideMenuRedcuerAction(SideMenuReducer.Action)
        case channelChattingReducerAction(ChannelChattingReducer.Action)
        case createChannelReducerAction(CreateChannelReducer.Action)
        case presentCreateView // 그룹 생성뷰 띄울지 말지
        case toggleReloginAlert // 토큰 갱신 알림
        case viewDidDisappear // 뷰 사라짐
        case presentAddChannelView
        case presentChannelActionView
        case presentExploringChannelView
        case presentSideMenu // 사이드메뉴 열기
        case dismissSideMenu // 사이드메뉴 닫기
        case toggleExpandedChannels // 채널 열고닫기
        case toggleExpandedDms // DM 열고 닫기
        case toggleInviteMemeberView // 멤버 초대 열고 닫기
        case inviteMemeber // 멤버 초대하기
        case changedMemberEmail // 멤버 이메일 변경 시마다 이메일유효성 증명
        case getWorkspaceDetail // 상세정보 받아오기
        case changedWorkspaceDetail(WorkspaceDetailDTO) // 그룹 선택할 때마다 상세정보 받아오기
        case setStudyGroupInfos(StudyGroupDetail) // 스터디그룹 정보
        case setStudyGroupChannels([StudyGroupChannel]) // 스터디그룹 채널 정보
        case setStudyGroupMembers([StudyGroupMember]) // 스터디그룹 멤버 정보
        case getAllMyChannels // 내가 속한 모든 채널 가져오기
        case getUnreadChannelsCount([ChannelDTO]) // 채널의 안 읽은 메시지 개수 가져오기
        case getDmList // DM 조회하기
        case getUnreadDmCounts([DmDTO]) // 안 읽은 DM 개수 조회
        case setDmList([DirectMessage]) // 조회한 DM 내역 보여주기
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.channelChattingReducerState, action: \.channelChattingReducerAction) {
            ChannelChattingReducer()
        }
 
        Scope(state: \.exploreChannelReducerState, action: \.exploreChannelReducerAction) {
            ExploringChannelReducer()
        }

        Scope(state: \.sideMenuReducerState, action: \.sideMenuRedcuerAction) {
            SideMenuReducer()
        }
        
        Scope(state: \.createChannelReducerState, action: \.createChannelReducerAction) {
            CreateChannelReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .exploreChannelReducerAction(.setSelectedChannel(_)):
                state.channelChattingReducerState = .init(selectedChannel: state.$selectedChannel,
                                                          chatList: state.$channelChatList)
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
                state.createChannelReducerState = .init(id: state.group?.groupId)
                state.isPresentingAddChannelView.toggle()
                return .none
                
            case .presentChannelActionView:
                state.isPresentingChannelActionView.toggle()
                return .none
                
            case .presentExploringChannelView:
                state.exploreChannelReducerState = .init(isPresentingExploringChannelView: state.$isPresentingExploringChannelView,
                                                         group: state.$group,
                                                         selectedChannel: state.$selectedChannel,
                                                         chatList: state.$channelChatList)
                state.isPresentingExploringChannelView.toggle()
                return .none
                
            case .presentSideMenu:
                state.isPresentingSideMenu = true
                return .none
                
            case .dismissSideMenu:
                state.isPresentingSideMenu = false
                return .none
                
            case .toggleExpandedChannels:
                state.isExpandedChannels.toggle()
                return .none
                
            case .toggleExpandedDms:
                state.isExpandedDms.toggle()
                return .none
                
            case .toggleInviteMemeberView:
                state.isPresentingInviteMemeberView.toggle()
                return .none
                
            case .inviteMemeber:
                return .run { [email = state.memberEmail, group = state.group] send in
                    guard let group else { return }
                    do {
                        let _ = try await NetworkService.shared.inviteWorkspaceMemeber(workspaceId: group.groupId, email: email)
                        await send(.toggleInviteMemeberView)
                    } catch {
                        print(error)
                    }
                }
                
            case .changedMemberEmail:
                let isValid = state.memberEmail.isValidEmail
                state.isDisabledInviteMember = !isValid
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
                return .concatenate (
                    .send(.setStudyGroupInfos(detail.toStudyGroupDetail())),
                    .send(.getAllMyChannels),
                    .send(.getDmList),
                    .send(.setStudyGroupMembers(detail.workspaceMembers.map { $0.toStudyGroupMember() }))
                )
                
            case .getAllMyChannels: // 내가 속한 모든 채널 가져오기
                return .run { [group = state.group] send in
                    guard let group else { return }
                    do {
                        let result = try await NetworkService.shared.getAllMyChannels(workspaceId: group.groupId)
                        await send(.getUnreadChannelsCount(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .getUnreadChannelsCount(let channels): // 내가 속한 채널에서 채널 내 안 읽은 메시지수 조회
                return .run { [info = state.studyGroupInfos] send in
                    guard let info else { return }
                    var studyGroupChannels: [StudyGroupChannel] = []
                    
                    for channel in channels {
                        var lastReadDate = channel.createdAt
                        
                        do {
                            // Realm Incorrect Thread 해결위해 main에서 처리
                            DispatchQueue.main.sync {
                                lastReadDate = ChatRepository.shared.getChannelLastReadDate(channelId: channel.channelId, createdAt: channel.createdAt)
                            }
                
                            let result = try await NetworkService.shared.getUnreadChannels(workspaceId: info.workspaceId, channelId: channel.channelId, after: lastReadDate)
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
                
            default:
                return .none
            }
        }
    }
}

