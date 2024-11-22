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
import NetworkKit
import UI

public struct FeatureView: View {
    public init() {
        UITabBar.appearance().backgroundColor = UIColor(Resources.Colors.white)
    }
    
    @State private var selectedTab = 0
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            MainHomeView(store: .init(initialState: MainHomeReducer.State(), reducer: {
                MainHomeReducer()
            }))
            .tabItem {
                VStack {
                    selectedTab == 0 ? Resources.Images.homeActive : Resources.Images.home
                    Text("홈")
                }
            }
            .tag(0)
        }
        .tint(Resources.Colors.black)
    }
}
