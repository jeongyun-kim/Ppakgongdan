//
//  DividerWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

private struct DividerWrapper: ViewModifier {
    func body(content: Content) -> some View {
        Divider()
            .foregroundStyle(Resources.Colors.seperator)
    }
}

extension View {
    public func customDivider() -> some View {
        modifier(DividerWrapper())
    }
}

