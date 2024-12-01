//
//  FriendChattingView.swift
//  UI
//
//  Created by 김정윤 on 11/24/24.
//

import SwiftUI

public struct FriendChattingView: View {
    public init(name: String, message: String, images: [String], date: String) {
        self.name = name
        self.message = message
        self.images = images
        self.date = date
    }
    
    private let name: String
    private let message: String
    private let date: String
    private let images: [String]
    
    private let width: CGFloat = 244
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(alignment: .top, spacing: 8) {
                RoundedImageView(imageViewCase: .chattingProfile)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(Resources.Fonts.caption)
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            ChatView(message: message)
                            
                            if !images.isEmpty {
                                Resources.Images.defaultGroupImage
                                    .resizable()
                                    .frame(height: 162)
                                    .frame(maxWidth: width)
                            }
                        }
                        
                        Text(date.toChattingDate())
                            .font(.caption2)
                            .foregroundStyle(Resources.Colors.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
