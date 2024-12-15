//
//  SideMenu.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/11/24.
//

import SwiftUI
import UI
import NetworkKit
import ComposableArchitecture
import Utils

public struct SideMenuView: View {
    public init(store: StoreOf<SideMenuReducer>) {
        self.store = store
    }

    @Bindable private var store: StoreOf<SideMenuReducer>
    
    public var body: some View {
        ZStack(alignment: .leading){
            if store.isPresentingSideMenu {
                Resources.Colors.viewAlpha
                    .onTapGesture {
                        store.send(.dismissSideMenu)
                    }
                if store.studyGroupList.isEmpty {
                    baseView(emptyContentView())
                } else {
                    baseView(contentView(store.studyGroupList))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.5), value: store.isPresentingSideMenu)
        .onChange(of: store.isPresentingSideMenu, { oldValue, newValue in
            guard newValue else { return }
            store.send(.getStudyGroups)
        })
        .onChange(of: store.isPresentingCreateView) { oldValue, newValue in
            guard !newValue else { return }
            store.send(.getStudyGroups)
        }
    }
}

extension SideMenuView {
    // MARK: SideMenuBgView
    private func baseView(_ view: some View) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Resources.Corners.sideMenu)
                    .fill(Resources.Colors.white)
                VStack {
                    titleView(geometry.size.height)
                    view
                    VStack(spacing: 0) {
                        bottomButtonView(image: Resources.Images.plus, text: "스터디그룹 추가")
                            .onTapGesture {
                                store.send(.toggleCreateView)
                            }
                        bottomButtonView(image: Resources.Images.help, text: "도움말")
                        .padding(.bottom, 33)
                    }
                }
            }
            .frame(width: geometry.size.width * 0.8)
            .frame(maxHeight: .infinity)
            .sheet(isPresented: $store.isPresentingCreateView) {
                CreateStudyGroupView(store: store.scope(state: \.createGroupReducerState,
                                                        action: \.createGroupReducerAction))
            }
        }
        .transition(.move(edge: .leading))
        .background(.clear)
    }
    
    // MARK: ContentView
    private func contentView(_ groups: [StudyGroup]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(groups, id: \.groupId) { item in
                    let isSelected = UserDefaultsManager.shared.recentGroupId == item.groupId
                    studyGroupRowView(item, isSelected: isSelected)
                        .confirmationDialog("스터디그룹 설정", isPresented: $store.isPresentingSettingActionSheet) {
                            actionSheetView(store.group)
                        }
                        .fullScreenCover(isPresented: $store.isPresentingSettingAlert) {
                            AlertView()
                                .presentationBackground(Resources.Colors.viewAlpha)
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                }
            }
        }
    }
    
    // MARK: AlertView
    private func AlertView() -> some View {
        if let group = store.group, group.ownerId == UserDefaultsManager.shared.userId {
            SettingAlertView(alertCase: .owner,
                             store: store.scope(state: \.alertReducerState, action: \.alertReducerAction))
        } else {
            SettingAlertView(alertCase: .nonOwner,
                             store: store.scope(state: \.alertReducerState, action: \.alertReducerAction))
        }
    }
    
    // MARK: StudyGroupRowView
    private func studyGroupRowView(_ item: StudyGroup, isSelected: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Resources.Corners.normal)
                .fill(isSelected ? Resources.Colors.gray : Resources.Colors.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            HStack {
                RoundedRectangle(cornerRadius: Resources.Corners.normal)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Resources.Images.defaultGroupImage
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: Resources.Corners.normal))
                    }
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.groupName)
                        .font(Resources.Fonts.bodyBold)
                        .frame(height: 18)
                    Text(item.createdAt.toSideMenuDate())
                        .font(Resources.Fonts.body)
                        .foregroundStyle(Resources.Colors.textSecondary)
                        .frame(height: 18)
                }
                Spacer()
                if isSelected {
                    Button {
                        store.send(.toggleSettingActionSheet)
                    } label: {
                        Resources.Images.threeDots
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .onTapGesture {
            store.send(.changedStudyGroup(item))
        }
    }
    
    // MARK: SettingActionSheet
    private func actionSheetView(_ item: StudyGroup?) -> some View {
        if let item, item.ownerId == UserDefaultsManager.shared.userId {
            return VStack {
                Button("스터디그룹 편집") {
                    print("편집")
                }
                Button("스터디그룹 나가기") {
                    store.send(.toggleSettingAlert)
                }
                Button("스터디그룹 관리자 변경") {
                    print("관리자 변경")
                }
                Button("스터디그룹 삭제", role: .destructive) {
                    store.send(.deleteStudyGroup(id: item.groupId))
                }
            }
        } else {
            return Button("스터디그룹 나가기") {
                store.send(.toggleSettingAlert)
            }
        }
    }
    // MARK: EmptyContentView
    private func emptyContentView() -> some View {
        VStack {
            Text("스터디그룹을\n찾을 수 없어요")
                .font(Resources.Fonts.title1)
                .padding(.top, 185)
                .padding(.horizontal, 24)
                .padding(.bottom, 19)
            
            Text("관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요 :)")
                .font(Resources.Fonts.body)
                .frame(width: 270, height: 75)
            
            nextButton("스터디그룹 생성", action: {
                store.send(.toggleCreateView)
            })
            .padding(.horizontal, 24)
            
            Spacer()
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

