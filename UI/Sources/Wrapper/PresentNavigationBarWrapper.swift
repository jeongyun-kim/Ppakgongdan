//
//  PresentNavigationBarWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

private struct PresentNavigationBarWrapper: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let size: CGFloat = 20
    
    init(title: String) {
        self.title = title
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Resources.Images.close
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .toolbarBackground(Resources.Colors.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    public func navigationBarForPresent(title: String) -> some View {
        modifier(PresentNavigationBarWrapper(title: title))
    }
}
