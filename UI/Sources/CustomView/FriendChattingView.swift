//
//  FriendChattingView.swift
//  UI
//
//  Created by 김정윤 on 11/24/24.
//

import SwiftUI

public struct FriendChattingView: View {
    public init(name: String, message: String, date: String, images: [String]) {
        self.name = name
        self.message = message
        self.date = date
        self.images = images
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
                            Text(message)
                                .font(Resources.Fonts.body)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: width, alignment: .leading)
                                .fixedSize(horizontal: true, vertical: true)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Resources.Colors.inActive, lineWidth: 1)
                                }
                            
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
            .padding(.vertical, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
