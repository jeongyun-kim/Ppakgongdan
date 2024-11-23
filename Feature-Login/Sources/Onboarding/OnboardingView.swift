//
//  OnboardingView.swift
//  Feature-Login
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI
import AuthenticationServices
import UI
import Utils
import ComposableArchitecture

public struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(UDKey.isUser.rawValue) var isUser = UserDefaults.standard.bool(forKey: UDKey.isUser.rawValue)
    @Bindable private var store: StoreOf<OnboardingReducer>
    @State private var presentingSheet: Bool = false
    
    public init(store: StoreOf<OnboardingReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("빡공단을 사용하면 어디서나\n스터디그룹을 만들 수 있어요")
                    .frame(height: 60)
                    .padding(.horizontal, 24)
                    .padding(.top, 33)
                    .font(Resources.Fonts.title1)
                Resources.Images.onboarding
                    .padding(.top, 89)
                    .padding(.horizontal, 12)
                Spacer()
                nextButton("시작하기") {
                    store.send(.togglePresentingSheet)
                }
                .frame(width: 323)
            }
            .padding(.bottom, 11)
        }
        .sheet(isPresented: $store.isPresentingSheet) {
            sheetLoginView()
                .sheet(isPresented: $presentingSheet, content: {
                    EmailLoginView(store: .init(initialState: EmailLoginReducer.State(), reducer: {
                        EmailLoginReducer()
                    }))
                })
        }
        
        .onChange(of: isUser) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

extension OnboardingView {
    // MARK: 로그인(카카오/애플/이메일)
    private func sheetLoginView() -> some View {
        VStack(spacing: 16) {
            nextButton()
                .frame(width: 323)
                .overlay {
                    Resources.Images.appleLogin
                    appleLoginButton()
                }
            
            nextButton()
                .frame(width: 323)
                .overlay {
                    Resources.Images.kakaoLogin
                        .onTapGesture {
                            store.send(.kakaoLoginBtnTapped)
                        }
                }
            
            nextButton()
                .frame(width: 323)
                .overlay {
                    Resources.Images.emailLogin
                        .resizable()
                        .onTapGesture {
                            presentingSheet.toggle()
                        }
                }
                
            HStack(spacing: 4) {
                Text("또는")
                Text("새로 회원가입 하기")
                    .foregroundStyle(Resources.Colors.pointColor)
            }
            .font(Resources.Fonts.title2)
        }
        .cornerRadius(10)
        .presentationDetents([.height(290)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: 애플 로그인 버튼
    private func appleLoginButton() -> some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                store.send(.appleLoginBtnTapped(result))
            }
        )
        .blendMode(.overlay)
    }
}
