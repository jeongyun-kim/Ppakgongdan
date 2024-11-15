//
//  HomeView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/3/24.
//

import SwiftUI
import UI
import NetworkKit
import ComposableArchitecture

public struct HomeView: View {
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    // state값 바인딩해서 사용할 수 있도록 @Bindable
    @Bindable private var store: StoreOf<HomeReducer>
    
    public var body: some View {
        ZStack(alignment: .top) {
            if let data = store.group {
                defulatHomeView(item: data)
                SideMenuView(store: .init(
                    initialState: SideMenuReducer.State(
                        isPresenting: store.isPresentingSideMenu,
                        selectedGroup: store.$group,
                        groupCount: store.$groupCount),
                    reducer: { SideMenuReducer() })
                )
            }
        }
        .onDisappear {
            store.send(.viewDidDisappear)
        }
        .onChange(of: store.group, { oldValue, newValue in
            store.send(.getWorkspaceDetail)
        })
        .showReloginAlert(isPresenting: $store.isPresentingAlert)
    }
}

// MARK: UI
extension HomeView {
    private func defulatHomeView(item: StudyGroup) -> some View {
        NavigationStack {
            VStack(spacing: 0) {
                customDivider()
                
                Text(item.groupName)
                    .font(Resources.Fonts.title1)
                    .padding(.top, 35)
                    .padding(.bottom, 24)
            }
            .navigationBar(leadingImage: nil, trailingImage: nil, title: item.groupName) {
                store.send(.presentSideMenu)
            }
        }
    }
}

