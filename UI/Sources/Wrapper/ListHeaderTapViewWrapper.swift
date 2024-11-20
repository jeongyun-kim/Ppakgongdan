//
//  ListHeaderTapView.swift
//  UI
//
//  Created by 김정윤 on 11/20/24.
//

import SwiftUI

private struct ListHeaderTapViewWrapper: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                action()
            }
    }
}

extension View {
    public func asTappableHeaderView(action: @escaping () -> Void) -> some View {
        modifier(ListHeaderTapViewWrapper(action: action))
    }
}
