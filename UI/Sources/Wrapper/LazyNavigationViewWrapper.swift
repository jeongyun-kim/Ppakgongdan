//
//  LazyNavigationViewWrapper.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

public struct LazyNavigationViewWrapper<Content: View>: View { // 감싸줄 뷰 = Content
    // 감싸줄 뷰 빌드
    private let build: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.build = content
    }
    
    public var body: some View {
        build()
    }
    
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
}
