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
        case getAllChannels
        case setAllChannels([Channel])
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
                        await send(.setAllChannels(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .setAllChannels(let channels):
                let studyGroupChannels = channels.map { $0.toStudyGroupChannel() }
                state.channelList = studyGroupChannels
                return .none
            }
        }
    }
}
