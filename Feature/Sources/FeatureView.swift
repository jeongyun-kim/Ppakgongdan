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
    public init(store: StoreOf<FeatureReducer>) {
        self.store = store
        UITabBar.appearance().backgroundColor = UIColor(Resources.Colors.white)
    }
    
    private var store: StoreOf<FeatureReducer>
    @State private var selectedTab = 0
    
    public var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                Group {
                    NavigationStack {
                        MainHomeView(store: store.scope(state: \.featureHome, action: \.featureHome))
                    }
                    .tabItem {
                        VStack {
                            selectedTab == 0 ? Resources.Images.homeActive : Resources.Images.home
                            Text("홈")
                        }
                    }
                    .tag(0)
                }
            }
            
            SideMenuView(store: store.scope(state: \.featureHome.homeReducerState.sideMenuReducerState, action: \.featureHome.homeReducerAction.sideMenuRedcuerAction))
        }
    }
}
