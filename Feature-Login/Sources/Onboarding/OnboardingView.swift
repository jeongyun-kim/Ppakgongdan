//
//  OnboardingView.swift
//  Feature-Login
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI
import Common

public struct OnboardingView: View {
    @State private var presentLogin = false
    
    public init() { }
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
                    presentLogin.toggle()
                }
            }
            .padding(.bottom, 11)
        }
        .sheet(isPresented: $presentLogin) {
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
                Text(" 새로 회원가입 하기")
                    .foregroundStyle(Resources.Colors.pointColor)
            }
            .font(Resources.Fonts.title2)
        }
        .cornerRadius(10)
        .presentationDetents([.height(290)])
        .presentationDragIndicator(.visible)
    }
    
}
