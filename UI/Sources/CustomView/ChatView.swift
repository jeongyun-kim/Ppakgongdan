//
//  ChatView.swift
//  UI
//
//  Created by 김정윤 on 11/28/24.
//

import SwiftUI

struct ChatView: View {
    init(message: String) {
        self.message = message
    }
    
    private let message: String
    private let width: CGFloat = 244
    
    public var body: some View {
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
    }
}
