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
        public init(isPresentingExploringChannelView: Shared<Bool>, id: String?) {
            _isPresentingExploringChannelView = isPresentingExploringChannelView
            self.id = id
        }
        
        @Shared var isPresentingExploringChannelView: Bool
        
        var id: String?
        var channelList: [StudyGroupChannel] = []
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case getAllChannels // 현워크스페이스의 모든 채널 리스트 가져오기
        case getAllMyChannels([Channel]) // 현워크스페이스 내 내가 속한 모든 채널 리스트 가져오기
        case setAllChannels([StudyGroupChannel]) // 뷰를 위한 채널리스트 세팅
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
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
