//
//  NextButtonWrapper.swift
//  Common
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI

private struct NextButtonWrapper: ViewModifier {
    private let title: String
    private let action: () -> Void
    @Binding private var isDisabled: Bool
    
    init(title: String, action: @escaping () -> Void, isDisabled: Binding<Bool>) {
        self.title = title
        self.action = action
        _isDisabled = isDisabled
    }
    
    func body(content: Content) -> some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDisabled ?
                          Resources.Colors.inActive : Resources.Colors.primaryColor)
                    .frame(width: 323, height: 44)
                Text(title)
                    .font(Resources.Fonts.title2)
                    .foregroundStyle(Resources.Colors.white)
            }
        }
        .disabled(isDisabled)
    }
}

extension View {
    public func nextButton(_ title: String = "", action: @escaping () -> Void = { }, isDisabled: Binding<Bool> = .constant(false)) -> some View {
        modifier(NextButtonWrapper(title: title, action: action, isDisabled: isDisabled))
    }
}
