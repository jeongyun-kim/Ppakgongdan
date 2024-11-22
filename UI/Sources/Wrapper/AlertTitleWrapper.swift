//
//  AlertTitleWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/22/24.
//

import SwiftUI

private struct AlertTitleWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Resources.Fonts.title2)
            .padding(.bottom, 8)
            .padding(.top, 16)
    }
}

extension View {
    public func asAlertTitle() -> some View {
        modifier(AlertTitleWrapper())
    }
}
