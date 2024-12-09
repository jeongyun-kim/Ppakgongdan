//
//  UnreadCountView.swift
//  UI
//
//  Created by 김정윤 on 12/9/24.
//

import SwiftUI

public struct UnreadCountView: View {
    public init(_ text: String) {
        self.text = text
    }
    
    private var text: String
    
    public var body: some View {
        Text(text)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .font(Resources.Fonts.caption)
            .foregroundStyle(Resources.Colors.white)
            .background(Resources.Colors.secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: Resources.Corners.normal))
    }
}
