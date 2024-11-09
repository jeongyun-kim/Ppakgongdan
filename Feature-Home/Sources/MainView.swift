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

public struct MainView: View {
    @State private var isEmpty = false
    @State private var studyGroupData: StudyGroup? = nil
    @State private var isPresentingAlert: Bool = false
    
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
        .showReloginAlert(isPresenting: $isPresentingAlert)
        .task {
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
            } catch {
                print(error)
                guard let errorCode = error as? ErrorCodes else { return }
                guard errorCode == .E05 else { return }
            }
        }
        
    }
       
}
