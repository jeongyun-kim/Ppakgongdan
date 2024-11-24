//
//  ExploringChannelView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/21/24.
//

import SwiftUI
import UI
import NetworkKit
import ComposableArchitecture

struct ExploringChannelView: View {
    init(path: Binding<NavigationPath>, store: StoreOf<ExploringChannelReducer>) {
        self.store = store
        _path = path
    }

    @Bindable private var store: StoreOf<ExploringChannelReducer>
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack {
            exploringChannelView()
        }
        .onAppear {
            store.send(.getAllChannels)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

extension ExploringChannelView {
    // MARK: ExploringChannelView
    private func exploringChannelView() -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(store.channelList, id: \.channelId) { item in
                    Button {
                        if !item.isContains {
                            store.send(.toggleJoinAlert(selected: item))
                        } else {
                            dismissExploringViewAndPushChattingView()
                        }
                    } label: {
                        channelRowView(item)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarForPresent(title: "채널 탐색")
    }
    
    // MARK: ChannelRowView
    private func channelRowView(_ item: StudyGroupChannel) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Resources.Images.hashTag
                .frame(width: 18, height: 18)
            
            Text(item.name)
                .font(Resources.Fonts.bodyBold)
        }
        .frame(height: 41)
        .fullScreenCover(isPresented: $store.isPresentingJoinAlert) {
            joinAlertView()
                .presentationBackground(Resources.Colors.viewAlpha)
        }
    }
    
    private func joinAlertView() -> some View {
        AlertView(height: 138) {
            VStack {
                Text("채널 참여")
                    .asAlertTitle()
                
                Text("[\(store.selectedChannel?.name ?? "")] 채널에 참여하시겠습니까?")
                    .asAlertDesc()
                
                HStack(spacing: 8) {
                    nextButton("취소", isDisabled: .constant(true))
                        .onTapGesture {
                            store.send(.dismissJoinAlert)
                        }
                    nextButton("확인") {
                        dismissExploringViewAndPushChattingView()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
    }
    
    private func dismissExploringViewAndPushChattingView() {
        store.send(.dismissExploringChannelView)
        path.append(NavigationViewCase.channelChattingView)
    }
}
