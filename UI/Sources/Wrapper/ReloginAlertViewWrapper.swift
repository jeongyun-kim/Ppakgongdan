//
//  ReloginAlertViewWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/7/24.
//

import SwiftUI
import Utils

private struct ReloginAlertViewWrapper: ViewModifier {
    let isPresenting: Binding<Bool>
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert("로그인 세션 만료", isPresented: isPresenting) {
                Button("확인") {
                    UserDefaultsManager.shared.deleteAllData()
                    action?()
                }
            } message: {
                Text("로그인 세션이 만료됐어요\n재로그인 해주세요")
            }
    }
}

extension View {
    public func showReloginAlert(isPresenting: Binding<Bool>, action:  (() -> Void)? = nil) -> some View {
        modifier(ReloginAlertViewWrapper(isPresenting: isPresenting, action: action))
    }
}
