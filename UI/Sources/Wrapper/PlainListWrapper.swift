//
//  PlainListWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/20/24.
//

import SwiftUI

private struct PlainListWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .background(Resources.Colors.white)
            .scrollContentBackground(.hidden)
    }
}

extension List {
    public func asPlainList() -> some View {
        modifier(PlainListWrapper())
    }
}
