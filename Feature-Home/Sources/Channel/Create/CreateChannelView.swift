//
//  CreateChannelView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/21/24.
//

import SwiftUI
import UI
import Utils
import ComposableArchitecture

struct CreateChannelView: View {
    @Environment(\.dismiss) private var dismiss
    public init(store: StoreOf<CreateChannelReducer>) {
        self.store = store
    }
    
    @Bindable var store: StoreOf<CreateChannelReducer>
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    verticalTextFieldView("채널 이름", placeHolder: "채널 이름을 입력하세요 (필수)", text: $store.channelName)
                        .padding(.vertical, 24)
                    
                    verticalTextFieldView("채널 설명", placeHolder: "채널을 설명하세요 (선택)", text: $store.channelDesc)
                        .padding(.bottom, 144)
   
                    nextButton("생성", action:  {
                        store.send(.createNewChannel)
                    }, isDisabled: $store.isDisabled)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Resources.Colors.bgPrimary)
            .navigationBarForPresent(title: "채널 생성")
            .onChange(of: store.channelName) { _, _ in
                store.send(.validateChannelName)
            }
            .onChange(of: store.isCompleted, { _, _ in
                dismiss()
            })
            .showReloginAlert(isPresenting: $store.isPresentingReloginAlert)
            .onTapGesture(count: 99, perform: { })
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
}

extension CreateChannelView {
    // MARK: VerticalTextFieldView
    private func verticalTextFieldView(_ title: String, placeHolder: String, text: Binding<String>) -> some View {
        VStack(spacing: 8) {
            TitleTextView(title)
            RoundedTextFieldView(placeHolder: placeHolder, text: text)
        }
    }
}
