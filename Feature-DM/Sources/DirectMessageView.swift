//
//  DirectMessageView.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/9/24.
//

import SwiftUI
import UI
import ComposableArchitecture

public struct DirectMessageView: View {
    public init(store: StoreOf<DirectMessageReducer>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<DirectMessageReducer>
    
    public var body: some View {
        VStack {
            dmHorizontalView()
            List {
                ForEach(0..<3) {_ in
                    dmListRowView()
                }
            }
            .asPlainList()
        }
        .navigationBar(title: "Direct Message")
    }
}

extension DirectMessageView {
    // MARK: DmListRowView
    private func dmListRowView() -> some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: 8) {
                RoundedImageView(imageViewCase: .chattingProfile)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("닉네임")
                        .font(Resources.Fonts.body)
                    Text("내용ㄹㅇ므링므리ㅏ믕리므일믱르미ㅏ으리마ㅡ리므리ㅏ므리믕리믜ㅏㄹ의므리마ㅡㅇ리므리믜르미아르마ㅣ릐마으라ㅣㅁㅇ라ㅣ믕라미ㅡㅇ라ㅣㅁ느리ㅏ므ㅏ리ㅡㅁ아ㅣㄹ마이르미ㅏㅇ르ㅏㅣㅁ으라ㅣ믕라므아ㅣ르미ㅏ을미ㅏ으리ㅏㅁㅇ라ㅣ믕라ㅣ믕라ㅣㅡㅁ아ㅣ름아ㅣ르마ㅣㅇㄹ")
                        .font(Resources.Fonts.caption)
                        .foregroundStyle(Resources.Colors.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("PM 10:23")
                        .font(Resources.Fonts.caption)
                        .foregroundStyle(Resources.Colors.textSecondary)
                    
                    UnreadCountView("1")
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
                    ForEach(0..<3) { _ in
                        dmHorizontalRowView()
                    }
                }
                .frame(height: 98)
                .frame(maxWidth: .infinity)
            }
            customDivider()
        }
    }
    
    // MARK: DmHorizontalRowView
    private func dmHorizontalRowView() -> some View {
        VStack {
            RoundedImageView(imageViewCase: .horizontaldDmListProfile)
            Text("닉네임")
                .font(Resources.Fonts.body)
        }
        .frame(width: 76)
    }
}
