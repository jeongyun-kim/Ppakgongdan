//
//  SideMenu.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/11/24.
//

import SwiftUI
import UI

struct SideMenuView: View {
    @Binding var isPresenting: Bool
    @State private var isPresentingCreateView = false
    
    var body: some View {
        ZStack(alignment: .leading){
            if isPresenting {
                Resources.Colors.viewAlpha
                    .onTapGesture {
                        isPresenting.toggle()
                    }
                emptyContentView()
                    .transition(.move(edge: .leading))
                    .background(.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isPresenting)
    }
}

extension SideMenuView {
    // MARK: EmptyContentView
    private func emptyContentView() -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Resources.Corners.sideMenu)
                    .fill(Resources.Colors.white)
                VStack {
                    titleView(geometry.size.height)
                    
                    Text("스터디그룹을\n찾을 수 없어요")
                        .font(Resources.Fonts.title1)
                        .padding(.top, 185)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 19)
                    
                    Text("관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요 :)")
                        .font(Resources.Fonts.body)
                        .frame(width: 270, height: 75)
                    
                    nextButton("스터디그룹 생성", action: {
                        isPresentingCreateView.toggle()
                    })
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        bottomButtonView(image: Resources.Images.plus, text: "스터디그룹 추가")
                        bottomButtonView(image: Resources.Images.help, text: "도움말")
                        .padding(.bottom, 33)
                    }
                }
            }
            .frame(width: geometry.size.width * 0.8)
            .frame(maxHeight: .infinity)
            .sheet(isPresented: $isPresentingCreateView) {
                CreateStudyGroupView(store: .init(initialState: CreateStudyGroupReducer.State(), reducer: {
                    CreateStudyGroupReducer()
                }))
            }
        }
    }
    
    // MARK: BottomButtonView(도움말 등)
    private func bottomButtonView(image: Image, text: String) -> some View {
        HStack {
            image
                .resizable()
                .frame(width: 18, height: 18)
            Text(text)
                .font(Resources.Fonts.body)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 41)
        .padding(.horizontal, 24)
    }
    
    // MARK: TitleView
    private func titleView(_ height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Resources.Colors.bgPrimary)
                .frame(height: height * 0.15)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: Resources.Corners.sideMenu,
                        style: .continuous))
            HStack {
                Text("스터디그룹")
                    .font(Resources.Fonts.title1)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 51)
        }
    }
}

