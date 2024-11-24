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

@Reducer
public struct ExploringChannelReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(isPresentingExploringChannelView: Shared<Bool>, id: String?, selectedChannel: Shared<StudyGroupChannel?>) {
            _isPresentingExploringChannelView = isPresentingExploringChannelView
            _selectedChannel = selectedChannel
            self.id = id
        }
        
        @Shared var isPresentingExploringChannelView: Bool
        @Shared var selectedChannel: StudyGroupChannel?
        var id: String?
        
        var channelList: [StudyGroupChannel] = []
        var isPresentingJoinAlert = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case getAllChannels // 현워크스페이스의 모든 채널 리스트 가져오기
        case getAllMyChannels([Channel]) // 현워크스페이스 내 내가 속한 모든 채널 리스트 가져오기
        case setAllChannels([StudyGroupChannel]) // 뷰를 위한 채널리스트 세팅
        case toggleJoinAlert // 채널 참여 알림창 띄우거나 내리기
        case dismissExploringChannelView // 채널 탐색뷰 내리기
        case setSelectedChannel(StudyGroupChannel) // 선택한 채널 데이터 반영하기 
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
                
            case .setSelectedChannel(let channel):
                state.selectedChannel = channel
                return .none
                
            case .getAllChannels:
                return .run { [id = state.id] send in
                    guard let id else { return }
                    do {
                        let result = try await NetworkService.shared.getAllChannels(workspaceId: id)
                        await send(.getAllMyChannels(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .getAllMyChannels(let channels):
                return .run { [id = state.id] send in
                    var studyGroupChannelList = channels.map { $0.toStudyGroupChannel() }
                    guard let id else { return }
                    
                    do {
                        let result = try await NetworkService.shared.getAllMyChannels(workspaceId: id)
                        let studyGroupChannelsFromResult = result.map { $0.toStudyGroupChannel() }
                        
                        for idx in (0..<studyGroupChannelList.count) {
                            studyGroupChannelList[idx].isContains = studyGroupChannelsFromResult.contains(studyGroupChannelList[idx])
                        }
                        
                        await send(.setAllChannels(studyGroupChannelList))
                    } catch {
                        print(error)
                    }
                }
                
            case .setAllChannels(let channels):
                state.channelList = channels
                return .none
            }
        }
    }
}
