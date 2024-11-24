//
//  NavigationBarWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI
import Utils
import NetworkKit
import Kingfisher

// NavigationBar
private struct NavigationBarWrapper: ViewModifier {
    let leadingImage: String?
    let trailigImage: String?
    let title: String?
    let action: (() -> Void)?
    
    init(leadingImage: String? = nil, trailigImage: String? = nil, title: String? = nil, action: (() -> Void)?) {
        self.leadingImage = leadingImage
        self.trailigImage = trailigImage
        self.title = title
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: { leadingView() })
                ToolbarItem(placement: .topBarTrailing, content: { trailingView() })
            }
    }
    
    // MARK: LeadingView
    private func leadingView() -> some View {
       HStack(spacing: 0) {
            leadingImageView()
            
            Text(title ?? "빡공단")
                .font(Resources.Fonts.title1)
                .frame(height: 35)
                .padding(.leading, 8)
        }
       .onTapGesture {
           action?()
       }
    }
    
    // MARK: LeadingImageView
    private func leadingImageView() -> some View {
        RoundedImageView(imageViewCase: .groupCoverImage, imagePath: leadingImage)
    }
    
    // MARK: TrailingView
    private func trailingView() -> some View {
        Circle()
            .frame(width: 32, height: 32)
            .overlay {
                trailingImageView()
            }
            .padding(.leading, 12)
    }
    
    // MARK: TrailingImageView
    private func trailingImageView() -> some View {
        if let imagePath = trailigImage {
            return VStack {
                KFImage(imagePath.toURL)
                    .resizable()
                    .clipShape(Circle())
            }
        } else {
            return VStack {
                Resources.Images.noPhotoA
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}

// MARK: Extension
extension View {
    public func navigationBar(leadingImage: String? = nil, trailingImage: String? = nil, title: String? = nil, action: (() -> Void)? = nil) -> some View {
        modifier(NavigationBarWrapper(leadingImage: leadingImage, trailigImage: trailingImage, title: title, action: action))
    }
}
