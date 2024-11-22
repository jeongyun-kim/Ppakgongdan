//
//  AlertDescWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/22/24.
//

import SwiftUI

private struct AlertDescWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(Resources.Fonts.body)
            .foregroundStyle(Resources.Colors.textSecondary)
            .padding(.horizontal)
    }
}

extension View {
    public func asAlertDesc() -> some View {
        modifier(AlertDescWrapper())
    }
}
