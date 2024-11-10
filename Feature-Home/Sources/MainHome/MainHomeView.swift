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
import ComposableArchitecture
import Feature_Login

public struct MainHomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isEmpty = false
    @State private var studyGroupData: StudyGroup? = nil
    @State private var isPresentingReloginAlert: Bool = false
    @State private var isPresentingOnbaording: Bool = false
    @AppStorage(UDKey.isUser.rawValue) private var isUser = UserDefaults.standard.bool(forKey: UDKey.isUser.rawValue)
    
    public init() { }
    
    public var body: some View {
        ZStack {
            if isEmpty {
                EmptyHomeView(store: .init(initialState: HomeReducer.State(), reducer: {
                    HomeReducer()
                }))
            } else {
                HomeView(store: .init(initialState: HomeReducer.State(group: studyGroupData), reducer: {
                    HomeReducer()
                }))
            }
        }
        .showReloginAlert(isPresenting: $isPresentingReloginAlert, action: {
            isPresentingOnbaording.toggle()
        })
        .onChange(of: isUser, { oldValue, newValue in
            // 사용자가 로그인하면 다시 워크스페이스 받아오게 처리 
            getMyWorkspaces()
        })
        .onChange(of: scenePhase, { oldValue, newValue in
            // 홈을 보던 중 앱이 백그라운드나 전화받는 상태가 됐을 때, 최근 접속 그룹아이디 저장 
            if scenePhase == .background || scenePhase == .inactive {
                guard let studyGroupData else { return }
                print("👀 View Inactive or Background")
                UserDefaultsManager.shared.recentGroupId = studyGroupData.groupId
            }
        })
        .task {
            print("⚡️ MainView Task")
            guard UserDefaultsManager.shared.isUser else {
                isPresentingOnbaording.toggle()
                return
            }
            getMyWorkspaces()
        }
        .fullScreenCover(isPresented: $isPresentingOnbaording) {
            OnboardingView(store: .init(initialState: OnboardingReducer.State(), reducer: {
                OnboardingReducer()
            }))
        }
    }
       
    private func getMyWorkspaces() {
        Task {
            do {
                let result = try await NetworkService.shared.getMyWorkspaces()
                guard UserDefaultsManager.shared.recentGroupId.isEmpty else {
                    let data = result.filter { $0.workspaceId == UserDefaultsManager.shared.recentGroupId }[0]
                    let studyGroup = data.toStudyGroup()
                    studyGroupData = studyGroup
                    return
                }
                guard let group = result.first else { return }
                studyGroupData = group.toStudyGroup()
                // 최근 접속한 그룹없을 경우, 가장 최신에 만들어진 그룹을 최근 그룹으로 우선 저장 
                UserDefaultsManager.shared.recentGroupId = group.workspaceId
            } catch {
                guard let errorCode = error as? ErrorCodes else { return }
                guard errorCode == .E05 else { return }
                isPresentingReloginAlert.toggle()
            }
        }
    }
}
