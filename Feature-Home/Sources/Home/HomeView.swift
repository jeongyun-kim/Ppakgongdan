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
                        isPresenting: store.$isPresentingSideMenu,
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
    // MARK: DefaultHomeView
    private func defulatHomeView(item: StudyGroup) -> some View {
        NavigationStack {
            VStack(spacing: 0) {
                customDivider()
                listView()
            }
            .navigationBar(leadingImage: store.group?.coverImage, trailingImage: nil, title: item.groupName) {
                store.send(.presentSideMenu)
            }
        }
        .sheet(isPresented: $store.isPresentingAddChannelView) {
            CreateChannelView(store: .init(initialState: CreateChannelReducer.State(id: store.group?.groupId), reducer: {
                CreateChannelReducer()
            }))
        }
        .fullScreenCover(isPresented: $store.isPresentingExploringChannelView) {
            exploringChannelView()
        }
    }
    
    // MARK: ExploringChannelView
    private func exploringChannelView() -> some View {
        ExploringChannelView(
            store: .init(initialState: ExploringChannelReducer.State(
                isPresentingExploringChannelView: store.$isPresentingExploringChannelView,
                id: store.group?.groupId), reducer: {
            ExploringChannelReducer()
        }))
        // 채널 탐색에서 AlertView에 viewAlpha를 주고있기 때문에 이곳에도 해당사항 적용안되게 white로 고정
        .presentationBackground(Resources.Colors.white)
    }
    
    // MARK: ListView
    private func listView() -> some View {
        List {
            channelSectionView()
            dmSectionView()
            addRowView("팀원 추가")
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
        }
        .asPlainList()
        .frame(maxWidth: .infinity)
        .refreshable {
            store.send(.getWorkspaceDetail)
        }
        // 🧐 추후 listTopPadding 없애기
    }
    
    // MARK: DmSectionView
    private func dmSectionView() -> some View {
        Section(isExpanded: $store.isExpandedDms) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(store.dmList, id: \.roomId) { item in
                    dmRowView(item)
                }
                addRowView("새 메시지 시작")
                customDivider()
            }
            .listSectionSeparator(.hidden)
            .onAppear {
                store.send(.getWorkspaceDetail)
            }
        } header: {
            headerView("다이렉트 메시지", isExpanded: store.isExpandedDms)
                .asTappableHeaderView {
                    store.send(.toggleExpandedDms)
                }
        }
        .listRowInsets(.init())
        .listSectionSpacing(0)
    }
    
    // MARK: DmRowView
    private func dmRowView(_ item: DirectMessage) -> some View {
        let size: CGFloat = 24
        return HStack(spacing: 11) {
            Resources.Images.dummy
                .resizable()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: Resources.Corners.normal))
            
            Text(item.user.nickname)
                .font(Resources.Fonts.body)
                .foregroundStyle(Resources.Colors.textSecondary)
            
            if item.unreadCount > 0 {
                Spacer()
                unreadCountView("\(item.unreadCount)")
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
        .listRowSeparator(.hidden)
    }
    
    // MARK: ChannelSectionView
    private func channelSectionView() -> some View {
        Section(isExpanded: $store.isExpandedChannels) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(store.studyGroupChannels, id: \.channelId) { item in
                    channelRowView(item)
                }
                addRowView("채널 추가") {
                    store.send(.presentChannelActionView)
                }
                customDivider()
            }
            .listSectionSeparator(.hidden)
            .onAppear {
                store.send(.getWorkspaceDetail)
            }
        } header: {
            headerView("채널", isExpanded: store.isExpandedChannels)
                .asTappableHeaderView {
                    store.send(.toggleExpandedChannels)
                }
        }
        .listRowInsets(.init())
        .listSectionSpacing(0)
        .confirmationDialog("채널 추가", isPresented: $store.isPresentingChannelActionView) {
            Button("채널 생성") {
                store.send(.presentAddChannelView)
            }
            Button("채널 탐색") {
                store.send(.presentExploringChannelView)
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
                unreadCountView("\(item.unreadCount)")
            }
        }
        .frame(height: 41)
        .padding(.horizontal)
        .foregroundStyle(item.unreadCount > 0 ? Resources.Colors.black : Resources.Colors.textSecondary)
        .listRowSeparator(.hidden)
    }
    
    // MARK: UnreadCountView
    private func unreadCountView(_ text: String) -> some View {
        Text(text)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .font(Resources.Fonts.caption)
            .foregroundStyle(Resources.Colors.white)
            .background(Resources.Colors.secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: Resources.Corners.normal))
    }
    
    // MARK: AddRowView
    private func addRowView(_ title: String, action: (() -> Void)? = nil) -> some View {
        HStack {
            Resources.Images.plus
                .frame(width: 18, height: 18)
            Text(title)
                .font(Resources.Fonts.body)
        }
        .foregroundStyle(Resources.Colors.textSecondary)
        .frame(height: 41)
        .padding(.horizontal)
        .onTapGesture {
            action?()
        }
    }
    
    // MARK: HeaderView
    private func headerView(_ channelName: String, isExpanded: Bool) -> some View {
        let size: CGFloat = 20
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
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
            .frame(height: 56)
            .padding(.horizontal)
            
            if !isExpanded {
                customDivider()
            }
        }
        .background(Resources.Colors.white)
    }
}

