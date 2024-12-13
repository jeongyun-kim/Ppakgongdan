//
//  DirectMessageView.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/9/24.
//

import SwiftUI
import UI
import ComposableArchitecture
import NetworkKit

public struct DirectMessageView: View {
    public init(store: StoreOf<DirectMessageReducer>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<DirectMessageReducer>
    
    public var body: some View {
        VStack {
            dmHorizontalView()
            List {
                ForEach(store.dmList, id: \.roomId) { item in
                    dmListRowView(item)
                }
            }
            .asPlainList()
        }
        .navigationBar(title: "Direct Message")
        .onAppear {
            store.send(.viewOnAppear)
        }
    }
}

extension DirectMessageView {
    // MARK: DmListRowView
    private func dmListRowView(_ item: DmChatting) -> some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: 8) {
                RoundedImageView(imageViewCase: .chattingProfile)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.user.nickname)
                        .font(Resources.Fonts.body)
                    Text(item.content)
                        .font(Resources.Fonts.caption)
                        .foregroundStyle(Resources.Colors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.createdAt.toChattingDate())
                        .font(Resources.Fonts.caption)
                        .foregroundStyle(Resources.Colors.textSecondary)
                    
                    if item.unreadCount > 0 {
                        UnreadCountView("\(item.unreadCount)")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .listRowSeparator(.hidden)
    }
    
    // MARK: DmHorizontalView
    private func dmHorizontalView() -> some View {
        VStack {
            customDivider()
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(store.memberList, id: \.userId) { item in
                        dmHorizontalRowView(item)
                    }
                }
                .frame(height: 98)
                .frame(maxWidth: .infinity)
            }
            customDivider()
        }
    }
    
    // MARK: DmHorizontalRowView
    private func dmHorizontalRowView(_ item: StudyGroupMember) -> some View {
        NavigationLink {
            LazyNavigationViewWrapper(
                DirectMessageChattingView(store: store.scope(state: \.directMessageReducerState,
                                                             action: \.directMessageReducerAction)))
        } label: {
            VStack {
                RoundedImageView(imageViewCase: .horizontaldDmListProfile)
                Text(item.nickname)
                    .font(Resources.Fonts.body)
                    .foregroundStyle(Resources.Colors.textPrimary)
            }
            .frame(width: 76)
        }
        .simultaneousGesture(TapGesture().onEnded {
            store.send(.createDmChatRoom(item.userId))
        })
    }
}
