//
//  MainView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/8/24.
//

import SwiftUI
import UI
import Utils
import NetworkKit
import Feature_Login
import ComposableArchitecture

public struct MainHomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable private var store: StoreOf<MainHomeReducer>
    
    public init(store: StoreOf<MainHomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            if store.groupCount == 0 {
                EmptyHomeView(store: store.scope(state: \.homeReducerState, action: \.homeReducerAction))
            } else {
                HomeView(store: store.scope(state: \.homeReducerState, action: \.homeReducerAction))
            }
        }
        .showReloginAlert(isPresenting: $store.isPresentingReloginAlert, action: {
            store.send(.toggleOnboarding)
        })
        .onChange(of: UserDefaultsManager.shared.isUser, { oldValue, newValue in
            // 여기서 shared 통해 Onboarding과 공유하는 isUser를 만들고 싶었으나, 카카오 로그인 같은 경우 async가 불가능 -> 해결방법을 찾지못한 타협..
            guard newValue else { return }
            // 사용자가 로그인하면 다시 워크스페이스 받아오게 처리
            store.send(.getMyWorkspaces)
        })
        .onChange(of: scenePhase, { oldValue, newValue in
            // 홈을 보던 중 앱이 백그라운드나 전화받는 상태가 됐을 때, 최근 접속 그룹아이디 저장 
            if scenePhase == .background || scenePhase == .inactive {
                print("👀 View Inactive or Background")
                store.send(.viewDidDisappear)
            }
        })
        .onChange(of: store.groupCount, { oldValue, newValue in
            // 그룹 모두 삭제 후 새로 생성 시 이전 기록 날리고 새로 받아오기 위해 
            if newValue == 1 {
                store.send(.getMyWorkspaces)
            }
        })
        .onAppear {
            print("⚡️ MainView OnAppear")
            guard UserDefaultsManager.shared.isUser else {
                store.send(.toggleOnboarding)
                return
            }
            store.send(.getMyWorkspaces)
        }
        .fullScreenCover(isPresented: $store.isPresentingOnbaording) {
            OnboardingView(store: store.scope(state: \.onboardingReducerState,
                                              action: \.onboardingReducerAction))
        }
    }
}
