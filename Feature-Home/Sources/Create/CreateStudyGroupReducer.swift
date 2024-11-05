//
//  CreateStudyGroupReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/5/24.
//

import Utils
import ComposableArchitecture
import SwiftUICore

public struct CreateStudyGroupReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var studyGroupName = "" // 스터디그룹명
        var studyGroupDesc = "" // 스터디그룹 설명
        var isDisabled = true // 생성 버튼 활성화 여부
    }
    
    public enum Actoin: BindableAction {
        case binding(BindingAction<State>)
        case changedStudyGroupName
    }
    
    public var body: some Reducer<State, Actoin> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .changedStudyGroupName: // 스터디그룹명 입력할 때마다 조건 확인(1자 ~ 30자)
                let groupNameCnt = state.studyGroupName.trimmingCharacters(in: .whitespacesAndNewlines).count
                let result = groupNameCnt < 1 || groupNameCnt > 30
                state.isDisabled = result
                return .none
            }
        }
    }
}
