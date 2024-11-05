//
//  CreateStudyGroupView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI
import UI
import ComposableArchitecture

public struct CreateStudyGroupView: View {
    public init(store: StoreOf<CreateStudyGroupReducer>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<CreateStudyGroupReducer>

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    customDivider()
                        .padding(.bottom, 24)
                    
                    profileImageView()
                    
                    verticalTextFieldView("스터디그룹 이름",
                                          placeHolder: "스터디그룹 이름을 입력하세요(필수)",
                                          text: $store.studyGroupName)
                    .padding(.bottom, 24)
                    .onChange(of: store.studyGroupName) { 
                        store.send(.changedStudyGroupName)
                    }
                    
                    verticalTextFieldView("스터디그룹 설명",
                                          placeHolder: "스터디그룹 설명을 입력하세요(옵션)",
                                          text: $store.studyGroupDesc)
                    .padding(.bottom, 58)
                    
                    nextButton("완료", isDisabled: $store.isDisabled)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Resources.Colors.bgPrimary)
            .navigationBarForPresent(title: "스터디그룹 생성") 
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
    
    private func profileImageView() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Resources.Colors.primaryColor)
            .frame(width: 70, height: 70)
            .overlay {
                Resources.Images.workspace
                    .resizable()
                    .frame(width: 48, height: 60)
                    .offset(y: 4)
                Resources.Images.camera
                    .resizable()
                    .frame(width: 24, height: 24)
                    .offset(x: 29, y: 27)
            }
            .padding(.bottom, 16)
    }
    
    private func verticalTextFieldView(_ title: String, placeHolder: String, text: Binding<String>) -> some View {
        VStack(spacing: 8) {
            titleTextView(title)
            RoundedTextFieldView(placeHolder: placeHolder, text: text)
        }
    }
    
    private func titleTextView(_ title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Resources.Fonts.title2)
    }
}
