//
//  FeatureView.swift
//  Feature
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI
import Feature_Login
import Feature_Home
import ComposableArchitecture
import Utils

public struct FeatureView: View {
    public init() { }
    @AppStorage(UDKey.isUser.rawValue) private var isUser = UserDefaultsManager.shared.isUser
    
    public var body: some View {
        HomeView()
            .fullScreenCover(isPresented: .constant(!isUser)) {
                OnboardingView(store: .init(initialState: OnboardingReducer.State(), reducer: {
                    OnboardingReducer()
                }))
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
    }
}
