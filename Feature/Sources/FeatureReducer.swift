//
//  FeatureReducer.swift
//  Feature
//
//  Created by 김정윤 on 12/3/24.
//

import Feature_Home
import Feature_Login
import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
public struct FeatureReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            featureHome = MainHomeReducer.State()
        }
        var featureHome: MainHomeReducer.State
    }

    public enum Action {
        case featureHome(MainHomeReducer.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.featureHome, action: \.featureHome) {
            MainHomeReducer()
        }
    }
}
