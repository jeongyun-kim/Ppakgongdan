//
//  ExploringChannelReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/21/24.
//

import Foundation
import NetworkKit
import Utils
import ComposableArchitecture
import Database

@Reducer
public struct ExploringChannelReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(isPresentingExploringChannelView: Shared<Bool>, group: Shared<StudyGroup?>, selectedChannel: Shared<StudyGroupChannel?>, chatList: Shared<[ChannelChatting]>) {
            _isPresentingExploringChannelView = isPresentingExploringChannelView
            _selectedChannel = selectedChannel
            _chatList = chatList
            _group = group
        }
        
        @Shared var chatList: [ChannelChatting]
        @Shared var isPresentingExploringChannelView: Bool
        @Shared var selectedChannel: StudyGroupChannel?
        @Shared var group: StudyGroup?
        
        var channelList: [StudyGroupChannel] = []
        var isPresentingJoinAlert = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case getAllChannels // 현워크스페이스의 모든 채널 리스트 가져오기
        case getAllMyChannels([ChannelDTO]) // 현워크스페이스 내 내가 속한 모든 채널 리스트 가져오기
        case setAllChannels([StudyGroupChannel]) // 뷰를 위한 채널리스트 세팅
        case toggleJoinAlert // 채널 참여 알림창 띄우거나 내리기
        case dismissExploringChannelView // 채널 탐색뷰 내리기
        case setSelectedChannel(StudyGroupChannel) // 선택한 채널 데이터 반영하기
        case getSelectedChannelChatListFromServer(String) // 선택한 채널의 채팅 리스트 받아오기
        case setChannelChatList([ChannelChatting]) // 받아온 채팅 리스트 반영하기
        case setSelectedChannelChatListFromDB // DB로부터 받아온 채팅 리스트 반영
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .dismissExploringChannelView:
                state.isPresentingExploringChannelView.toggle()
                return .none
                
            case .toggleJoinAlert:
                state.isPresentingJoinAlert.toggle()
                return .none
                
            case .getAllChannels:
                return .run { [group = state.group] send in
                    guard let group else { return }
                    do {
                        let result = try await NetworkService.shared.getAllChannels(workspaceId: group.groupId)
                        await send(.getAllMyChannels(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .setAllChannels(let channels):
                state.channelList = channels
                return .none
                
            case .getAllMyChannels(let channels):
                return .run { [group = state.group] send in
                    guard let group else { return }
                    var studyGroupChannelList = channels.map { $0.toStudyGroupChannel() }
                    
                    do {
                        let result = try await NetworkService.shared.getAllMyChannels(workspaceId: group.groupId)
                        let studyGroupChannelsFromResult = result.map { $0.toStudyGroupChannel() }
                        
                        for idx in (0..<studyGroupChannelList.count) {
                            studyGroupChannelList[idx].isContains = studyGroupChannelsFromResult.contains(studyGroupChannelList[idx])
                        }
                        
                        await send(.setAllChannels(studyGroupChannelList))
                    } catch {
                        print(error)
                    }
                }
                
            case .setSelectedChannel(let channel):
                state.selectedChannel = channel
                return .send(.setSelectedChannelChatListFromDB)
                
            case .setSelectedChannelChatListFromDB:
                guard let channel = state.selectedChannel else { return .none }
                guard let channelChatRoom = ChatRepository.shared.readChannelChatRoom(roomId: channel.channelId) else {
                    return .send(.getSelectedChannelChatListFromServer(channel.createdAt))
                }
                state.chatList = Array(channelChatRoom.chats).compactMap { $0.toChannelChatting() }
                return .send(.getSelectedChannelChatListFromServer(channelChatRoom.lastReadDate))
                
            case .getSelectedChannelChatListFromServer(let after):
                return .run { [group = state.group, channel = state.selectedChannel] send in
                    guard let group, let channel else { return }
                    do {
                        let result = try await NetworkService.shared.getChannelChats(workspaceId: group.groupId, channelId: channel.channelId, after: after)
                        await send(.setChannelChatList(result.map { $0.toChannelChatting() }))
                    } catch {
                        print(error)
                    }
                }
                
            case .setChannelChatList(let list):
                state.chatList.append(contentsOf: list)
                guard let channel = state.selectedChannel else { return .send(.dismissExploringChannelView) }
                ChatRepository.shared.saveChannelChatRoom(roomId: channel.channelId, list: state.chatList)
                return .send(.dismissExploringChannelView)
            }
        }
    }
}
