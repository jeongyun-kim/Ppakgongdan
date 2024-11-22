//
//  AlertView.swift
//  UI
//
//  Created by 김정윤 on 11/22/24.
//

import SwiftUI

public struct AlertView<Content: View>: View {
    public init(height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.height = height
        self.content = content
    }
    
    let height: CGFloat
    let content: () -> Content
    private let width: CGFloat = 344
    private let radius: CGFloat = 16
    
    public var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .fill(Resources.Colors.white)
            .frame(width: width, height: height)
            .overlay {
                content()
            }
    }
}
