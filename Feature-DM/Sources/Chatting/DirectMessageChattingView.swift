//
//  DirectMessageChattingView.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/10/24.
//

import SwiftUI
import Combine
import UI
import NetworkKit
import Utils
import ComposableArchitecture

struct DirectMessageChattingView: View {
    @Bindable var store: StoreOf<DirectMessageChattingReducer>
    @State private var subscriptions = Set<AnyCancellable>()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List(store.chatList, id: \.dmId) { item in
                    chattingRowView(item)
                        .listRowSeparator(.hidden)
                }
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
                proxy.scrollTo(last.dmId)
            }
            .onChange(of: store.chatRoomInfo) { oldValue, newValue in
                guard let newValue else { return }
                store.send(.connectSocket)
            }
            .onChange(of: isFocused) { oldValue, newValue in
                guard newValue else { return }
                guard let last = store.chatList.last else { return }
                print("⭐️", last)
                proxy.scrollTo(last.dmId)
            }
        }
        .navigationTitle(store.chatRoomInfo?.user.nickname ?? "")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            SocketService.shared.bindChat { value in
                guard let chat = value as? DmChatting else { return }
                store.send(.appendChat(chat))
            }
        }
        .onDisappear {
            store.send(.disconnectSocket)
        }
    }
}

extension DirectMessageChattingView {
    // MARK: ChattingRowView
    private func chattingRowView(_ item: DmChatting) -> some View {
        if item.user.userId == UserDefaultsManager.shared.userId {
            return MyChattingView(name: item.user.nickname, message: item.content, images: item.files, date: item.createdAt)
        } else {
            return FriendChattingView(name: item.user.nickname, message: item.content, images: item.files, date: item.createdAt)
        }
    }
}
