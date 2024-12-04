//
//  AlertReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/15/24.
//

import Foundation
import Utils
import ComposableArchitecture
import NetworkKit

@Reducer
public struct SettingAlertReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init(group: Shared<StudyGroup?>, groupCount: Shared<Int>) {
            _group = group
            _groupCount = groupCount
        }
        
        @Shared var group: StudyGroup?
        @Shared var groupCount: Int
        var isPresentingReloginAlert = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case exitWorkspace
        case toggleReloginAlert
        case getCurrentWorkspace([StudyGroup])
        case changeGroupCount(Int)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .exitWorkspace:
                return .run { [group = state.group] send in
                    do {
                        guard let group else { return }
                        let result = try await NetworkService.shared.exitWorkspace(groupId: group.groupId)
                        let groups = result.map { $0.toStudyGroup() }
                        await send(.getCurrentWorkspace(groups))
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            case .getCurrentWorkspace(let groups):
                guard groups.count > 0 else {
                    state.group = nil
                    return .none
                }
                state.group = groups.first
                return .send(.changeGroupCount(groups.count))
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
                
            case .changeGroupCount(let count):
                UserDefaultsManager.shared.groupCount = count
                state.groupCount = count
                return .none
            }
        }
    }
}
