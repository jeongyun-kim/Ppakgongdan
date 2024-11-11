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
                SideMenuView(isPresenting: $store.isPresentingSideMenu)
            }
        }
        .onDisappear {
            store.send(.viewDidDisappear)
        }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    guard value.translation.width > 0 else {
                        store.send(.dismissSideMenu)
                        return 
                    }
                    store.send(.presentSideMenu)
                })
        )
        .showReloginAlert(isPresenting: $store.isPresentingAlert)
    }
}

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

