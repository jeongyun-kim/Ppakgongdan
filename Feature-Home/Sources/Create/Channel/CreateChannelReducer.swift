//
//  CreateChannelReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/21/24.
//

import Utils
import NetworkKit
import ComposableArchitecture

public struct CreateChannelReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(id: String?) {
            self.id = id
        }
        
        var id: String?
        var channelName = ""
        var channelDesc = ""
        var isDisabled = true
        var isCompleted = false
        var isPresentingReloginAlert = false
    }
    
    public enum Actoin: BindableAction {
        case binding(BindingAction<State>)
        case validateChannelName // 채널명 조건 확인 
        case createNewChannel // 새로운 채널 생성
        case completedTask // 채널 생성 후
        case toggleReloginAlert // 재로그인 필요한 경우
    }
    
    public var body: some Reducer<State, Actoin> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .validateChannelName:
                state.isDisabled = state.channelName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                return .none
                
            case .createNewChannel:
                return .run { [id = state.id, name = state.channelName, desc = state.channelDesc] send in
                    guard let id else { return }
                    do {
                        let result = try await NetworkService.shared.createNewChannel(workspaceId: id, name: name, desc: desc)
                        print(result)
                        await send(.completedTask)
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
            
            case .completedTask:
                state.isCompleted.toggle()
                return .none
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
            }
        }
    }
}

