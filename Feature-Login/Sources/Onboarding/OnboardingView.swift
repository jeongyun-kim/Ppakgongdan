//
//  OnboardingView.swift
//  Feature-Login
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI
import Common
import ComposableArchitecture

public struct OnboardingView: View {
    @Bindable private var store: StoreOf<OnboardingReducer>
    
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
                    store.send(.present)
                }
            }
            .padding(.bottom, 11)
        }
        .sheet(isPresented: $store.isPresenting) {
            sheetView()
        }
    }
    
    private func sheetView() -> some View {
        VStack(spacing: 16) {
            nextButton()
                .overlay {
                    Resources.Images.appleLogin
                }
            nextButton()
                .overlay {
                    Resources.Images.kakaoLogin
                }
            nextButton()
                .overlay {
                    Resources.Images.emailLogin
                        .resizable()
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
    
}
