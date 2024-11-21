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
    init(store: StoreOf<ExploringChannelReducer>) {
        self.store = store
    }
    
    private var store: StoreOf<ExploringChannelReducer>
    
    var body: some View {
        NavigationStack {
            exploringChannelView()
        }
        .onAppear {
            store.send(.getAllChannels)
        }
    }
}

extension ExploringChannelView {
    // MARK: ExploringChannelView
    private func exploringChannelView() -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(store.channelList, id: \.channelId) { item in
                    channelRowView(item)
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
    }
}
