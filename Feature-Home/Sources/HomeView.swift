//
//  HomeView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/3/24.
//

import SwiftUI
import UI

public struct HomeView: View {
    public init() { }
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Resources.Images.logo
                        .resizable()
                        .frame(width: 32, height: 32)
                        .cornerRadius(8)
                    Text("No StudyGroup")
                        .font(Resources.Fonts.title1)
                        .frame(height: 35)
                        .padding(.leading, 8)
                    Spacer()
                    Circle()
                        .frame(width: 32, height: 32)
                        .overlay {
                            Resources.Images.dummy
                                .resizable()
                                .clipShape(Circle())
                        }
                        .padding(.leading, 12)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                Divider()
                    .background(Resources.Colors.seperator)
                
                Text("스터디그룹을 찾을 수 없어요 :(")
                    .font(Resources.Fonts.title1)
                    .padding(.top, 35)
                    .padding(.bottom, 24)
                Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 스터디그룹을 생성해주세요.")
                    .font(Resources.Fonts.body)
                    .frame(height: 40)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)
                    
                Resources.Images.emptyHomeImage
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 368)
                
                Spacer()
                
                nextButton("스터디그룹 생성")
            }
            .padding(.bottom, 11)
        }
    }
}
