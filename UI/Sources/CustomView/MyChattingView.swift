//
//  MyChattingView.swift
//  UI
//
//  Created by 김정윤 on 11/28/24.
//

import SwiftUI

public struct MyChattingView: View {
    public init(name: String, message: String, images: [String], date: String) {
        self.name = name
        self.message = message
        self.images = images
        self.date = date
    }
    
    private let name: String
    private let message: String
    private let images: [String]
    private let date: String
    private let width: CGFloat = 244
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: 8) {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Text(date.toChattingDate())
                        .font(.caption2)
                        .foregroundStyle(Resources.Colors.textSecondary)
                    
                    VStack(alignment: .trailing) {
                        ChatView(message: message)
                        
                        if !images.isEmpty {
                            Resources.Images.defaultGroupImage
                                .resizable()
                                .frame(height: 162)
                                .frame(maxWidth: width)
                        }
                    }
                }
            }
        }
    }
}
