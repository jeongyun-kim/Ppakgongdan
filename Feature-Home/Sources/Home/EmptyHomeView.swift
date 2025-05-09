//
//  EmptyHomeView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/8/24.
//

import SwiftUI
import UI
import ComposableArchitecture

struct EmptyHomeView: View {
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    // state값 바인딩해서 사용할 수 있도록 @Bindable
    @Bindable private var store: StoreOf<HomeReducer>
    
    var body: some View {
        NavigationStack {
            emptyHomeView()
        }
        .sheet(isPresented: $store.isPresentCreateView) {
            CreateStudyGroupView(store: store.scope(state: \.sideMenuReducerState.createGroupReducerState,
                                                    action: \.sideMenuRedcuerAction.createGroupReducerAction))
            .presentationDragIndicator(.visible)
        }
    }
}

extension EmptyHomeView {
    private func emptyHomeView() -> some View {
        VStack(spacing: 0) {
            customDivider()
            
            Text("스터디그룹을 찾을 수 없어요")
                .font(Resources.Fonts.title1)
                .padding(.top, 35)
                .padding(.bottom, 24)
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 스터디그룹을 생성해주세요")
                .font(Resources.Fonts.body)
                .frame(height: 40)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
            Resources.Images.emptyHomeImage
                .resizable()
                .frame(width: 368, height: 368)
            
            Spacer()
            
            nextButton("스터디그룹 생성") {
                store.send(.presentCreateView)
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 11)
        .navigationBar()
    }
}
