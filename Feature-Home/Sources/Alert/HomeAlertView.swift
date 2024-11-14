//
//  OwnerExitAlertView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/14/24.
//

import SwiftUI
import UI
import Utils
import ComposableArchitecture

struct HomeAlertView: View {
    @Environment(\.dismiss) private var dismiss
    private var alertCase: AlertCase
    private var store: StoreOf<HomeAlertReducer>
    
    init(alertCase: AlertCase, store: StoreOf<HomeAlertReducer>) {
        self.alertCase = alertCase
        self.store = store
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Resources.Colors.white)
            .frame(width: 344, height: alertCase.height)
            .overlay {
                if alertCase == .owner {
                    ownerAlertView()
                } else {
                    nonOwnerAlertView()
                }
            }
    }
}

// MARK: AlertCaseEnum
extension HomeAlertView {
    enum AlertCase {
        case owner
        case nonOwner
        
        var height: CGFloat {
            switch self {
            case .owner:
                return 156
            case .nonOwner:
                return 138
            }
        }
        
        var title: String {
            switch self {
            case .owner, .nonOwner:
                return "스터디그룹 나가기"
            }
        }
        
        var desc: String {
            switch self {
            case .owner:
                return "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
            case .nonOwner:
                return "정말 이 스터디그룹을 떠나시겠습니까?"
            }
        }
    }
}

// MARK: UI
extension HomeAlertView {
    // MARK: DescView
    private func descView(_ alertCase: AlertCase) -> some View {
        Text(alertCase.desc)
            .multilineTextAlignment(.center)
            .font(Resources.Fonts.body)
            .foregroundStyle(Resources.Colors.textSecondary)
            .padding(.horizontal)
    }
    
    // MARK: TitleView
    private func titleView(_ alertCase: AlertCase) -> some View {
        Text(alertCase.title)
            .font(Resources.Fonts.title2)
            .padding(.bottom, 8)
            .padding(.top, 16)
    }
    
    // MARK: nonOwnerView
    private func nonOwnerAlertView() -> some View {
        VStack {
            titleView(.nonOwner)
            
            descView(.nonOwner)
                .frame(height: 11)
            
            HStack(spacing: 8) {
                nextButton("취소", isDisabled: .constant(true))
                    .onTapGesture {
                        dismiss()
                    }
                nextButton("나가기") {
                    store.send(.exitWorkspace)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
    
    // MARK: OwnerView
    private func ownerAlertView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            titleView(.owner)
            
            descView(.owner)
                .frame(height: 36)
            
            nextButton("확인") {
                dismiss()
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}
