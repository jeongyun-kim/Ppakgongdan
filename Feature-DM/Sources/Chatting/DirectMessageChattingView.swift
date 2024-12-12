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
                List(store.chatList, id: \.roomId) { item in
                    chattingRowView(item)
                        .listRowSeparator(.hidden)
                }
                .asPlainList()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollDismissesKeyboard(.immediately)
                
                ChattingInputView($store.text, isFocused: $isFocused) {
//                    store.send(.sendMyChat)
                }
            }
            .onChange(of: store.chatList) { oldValue, newValue in
                guard oldValue != newValue else { return }
                guard let last = newValue.last else { return }
                proxy.scrollTo(last.dmId)
            }
        }
        .navigationTitle("")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            store.send(.connectSocket)
            
//            SocketService.shared.chatPublisher
//                .receive(on: DispatchQueue.main)
//                .compactMap { $0 }
//                .sink { value in
//                    store.send(.appendChat(value))
//                }
//                .store(in: &subscriptions)
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
