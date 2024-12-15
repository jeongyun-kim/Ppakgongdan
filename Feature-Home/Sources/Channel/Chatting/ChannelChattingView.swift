//
//  ChannelChattingView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/23/24.
//

import SwiftUI
import UI
import NetworkKit
import Utils
import ComposableArchitecture
import Combine

struct ChannelChattingView: View {
    @FocusState private var isFocused: Bool
    @Bindable var store: StoreOf<ChannelChattingReducer>
    @State private var subscriptions = Set<AnyCancellable>()

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List(store.chatList, id: \.chatId, rowContent: { item in
                    chattingRowView(item)
                        .listRowSeparator(.hidden)
                })
                .asPlainList()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollDismissesKeyboard(.immediately)
                
                ChattingInputView($store.text, isFocused: $isFocused) {
                    store.send(.sendMyChat)
                }
            }
            .onChange(of: store.chatList) { oldValue, newValue in
                guard oldValue != newValue else { return }
                guard let last = newValue.last else { return }
                proxy.scrollTo(last.chatId)
            }
        }
        .navigationTitle("#\(store.selectedChannel?.name ?? "채널")")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            store.send(.connectSocket)

            SocketService.shared.bindChat { value in
                guard let chat = value as? ChannelChatting else { return }
                store.send(.appendChat(chat))
            }
        }
        .onDisappear {
            store.send(.disconnectSocket)
        }
    }
}

extension ChannelChattingView {
    // MARK: ChattingRowView
    private func chattingRowView(_ item: ChannelChatting) -> some View {
        if item.user.userId == UserDefaultsManager.shared.userId {
            return MyChattingView(name: item.user.nickname, message: item.content, images: item.files, date: item.createdAt)
        } else {
            return FriendChattingView(name: item.user.nickname, message: item.content, images: item.files, date: item.createdAt)
        }
    }
}
