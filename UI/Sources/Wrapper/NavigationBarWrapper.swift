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
    
    init(leadingImage: String? = nil, trailligImage: String? = nil, title: String? = nil) {
        self.leadingImage = leadingImage
        self.trailligImage = trailligImage
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: { leadingView(image: leadingImage, title: title) })
                ToolbarItem(placement: .topBarTrailing, content: { traillingView(image: trailligImage) })
            }
    }
    
    private func leadingView(image: String? = nil, title: String? = nil) -> some View {
        HStack(spacing: 0) {
            Resources.Images.logo
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(8)
            Text(title ?? "빡공단")
                .font(Resources.Fonts.title1)
                .frame(height: 35)
                .padding(.leading, 8)
        }
    }
    
    private func traillingView(image: String? = nil) -> some View {
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
    public func navigationBar(leadingImage: String? = nil, trailingImage: String? = nil, title: String? = nil) -> some View {
        modifier(NavigationBarWrapper(leadingImage: leadingImage, trailligImage: trailingImage, title: title))
    }
}
