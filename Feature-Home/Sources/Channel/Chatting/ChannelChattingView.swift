//
//  ChannelChattingView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/23/24.
//

import SwiftUI
import UI
import ComposableArchitecture

struct ChannelChattingView: View {
    @Bindable var store: StoreOf<ChannelChattingReducer>

    var body: some View {
        VStack {
            List(0..<10, rowContent: { i in
                Text("\(i)")
            })
            .asPlainList()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollDismissesKeyboard(.immediately)
            
            ChattingInputView($store.text) {
                print("tapped")
            }
        }
        .navigationTitle("#\(store.selectedChannel?.name ?? "채널")")
        .toolbarRole(.editor)
        .toolbar(.hidden, for: .tabBar)
    }
}

