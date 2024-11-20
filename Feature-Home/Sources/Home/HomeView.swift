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
                channelListView()
            }
            .navigationBar(leadingImage: nil, trailingImage: nil, title: item.groupName) {
                store.send(.presentSideMenu)
            }
        }
    }
    
    private func channelListView() -> some View {
        VStack(spacing: 0) {
            List {
                Section(isExpanded: $store.isExpandedChannels) {
                    ForEach(store.studyGroupChannels, id: \.channelId) { item in
                        channelRowView(item)
                    }
                } header: {
                    headerView("채널", isExpanded: store.isExpandedChannels)
                        .asTappableHeaderView {
                            store.send(.toggleExpandedChannels)
                        }
                }
            }
            .asPlainList()
        }
    }
    
    // MARK: HeaderView
    private func headerView(_ channelName: String, isExpanded: Bool) -> some View {
        let size: CGFloat = 20
        return HStack {
            Text(channelName)
                .font(Resources.Fonts.title2)
                .foregroundStyle(Resources.Colors.black)
            Spacer()
            if isExpanded {
                Resources.Images.chevronDown
                    .frame(width: size, height: size)
            } else {
                Resources.Images.chevronRight
                    .frame(width: size, height: size)
            }
        }
    }
    
    // MARK: ChannelRowView
    private func channelRowView(_ item: StudyGroupChannel) -> some View {
        HStack {
            Resources.Images.hashTag
                .frame(width: 18, height: 18)
            
            Text(item.name)
                .font(item.unreadCount > 0 ? Resources.Fonts.bodyBold : Resources.Fonts.body)

            if item.unreadCount > 0 {
                Spacer()
                Text("\(item.unreadCount)")
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .font(Resources.Fonts.caption)
                    .foregroundStyle(Resources.Colors.white)
                    .background(Resources.Colors.secondaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: Resources.Corners.normal))
            }
        }
        .frame(height: 41)
        .foregroundStyle(item.unreadCount > 0 ? Resources.Colors.black : Resources.Colors.textSecondary)
        .listRowSeparator(.hidden)
    }
}

