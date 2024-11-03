//
//  FeatureView.swift
//  Feature
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI
import Feature_Login
import ComposableArchitecture
import Utils

public struct FeatureView: View {
    @AppStorage(UDKey.isUser.rawValue) private var isUser = UserDefaultsManager.shared.isUser
    
    public init() { }
    public var body: some View {
        OnboardingView(store: .init(initialState: OnboardingReducer.State(), reducer: {
            OnboardingReducer()
        }))
    }
}
