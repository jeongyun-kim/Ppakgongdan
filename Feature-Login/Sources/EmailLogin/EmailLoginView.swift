//
//  EmailLoginView.swift
//  Feature-Login
//
//  Created by 김정윤 on 11/23/24.
//

import SwiftUI
import UI
import ComposableArchitecture

struct EmailLoginView: View {
    init(store: StoreOf<EmailLoginReducer>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<EmailLoginReducer>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                emailView()
                passwordView()
                nextButton("로그인", action: {
                    store.send(.login)
                }, isDisabled: $store.isDisabled)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 24)
            .background(Resources.Colors.bgPrimary)
            .navigationBarForPresent(title: "이메일 로그인")
            .presentationDragIndicator(.visible)
            .onTapGesture(count: 99, perform: { })
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
}

extension EmailLoginView {
    private func passwordView() -> some View {
        VStack(spacing: 8) {
            TitleTextView("비밀번호")
                .foregroundStyle(store.isValidPassword ? Resources.Colors.black : Resources.Colors.error)
            passwordSecureFieldView()
        }
        .padding(.bottom, 132)
        .onChange(of: store.password) { oldValue, newValue in
            store.send(.validatePassword)
        }
    }
    
    private func emailView() -> some View {
        VStack(spacing: 8) {
            TitleTextView("이메일")
                .foregroundStyle(store.isValidEmail ? Resources.Colors.black : Resources.Colors.error)
            RoundedTextFieldView(placeHolder: "이메일을 입력하세요", text: $store.email)
            
        }
        .padding(.vertical, 24)
        .onChange(of: store.email) { oldValue, newValue in
            store.send(.validateEmail)
        }
    }
    
    // MARK: PasswordSecureFieldView
    private func passwordSecureFieldView() -> some View {
        let height : CGFloat = 44
        return ZStack {
            RoundedRectangle(cornerRadius: Resources.Corners.normal)
                .fill(Resources.Colors.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
            
            SecureField("비밀번호를 입력하세요", text: $store.password)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Resources.Colors.white)
                .font(Resources.Fonts.body)
                .padding(.horizontal, 12)
        }
    }
}
