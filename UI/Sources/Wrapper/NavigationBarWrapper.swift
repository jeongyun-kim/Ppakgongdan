//
//  NavigationBarWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

// NavigationBar
private struct NavigationBarWrapper: ViewModifier {
    let leadingImage: String?
    let trailligImage: String?
    let title: String?
    let action: (() -> Void)?
    
    init(leadingImage: String? = nil, trailligImage: String? = nil, title: String? = nil, action: (() -> Void)?) {
        self.leadingImage = leadingImage
        self.trailligImage = trailligImage
        self.title = title
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: { leadingView() })
                ToolbarItem(placement: .topBarTrailing, content: { traillingView() })
            }
    }
    
    private func leadingView() -> some View {
        HStack(spacing: 0) {
            Resources.Images.logo
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(8)
            Text(title ?? "빡공단")
                .font(Resources.Fonts.title1)
                .frame(height: 35)
                .padding(.leading, 8)
                .onTapGesture {
                    action?()
                }
        }
    }
    
    private func traillingView() -> some View {
        Circle()
            .frame(width: 32, height: 32)
            .overlay {
                Resources.Images.dummy
                    .resizable()
                    .clipShape(Circle())
            }
            .padding(.leading, 12)
    }
}

extension View {
    public func navigationBar(leadingImage: String? = nil, trailingImage: String? = nil, title: String? = nil, action: (() -> Void)? = nil) -> some View {
        modifier(NavigationBarWrapper(leadingImage: leadingImage, trailligImage: trailingImage, title: title, action: action))
    }
}
