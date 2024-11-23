//
//  TitleTextView.swift
//  UI
//
//  Created by 김정윤 on 11/23/24.
//

import SwiftUI

public struct TitleTextView: View {
    public init(_ text: String) {
        self.text = text
    }
    
    let text: String
    
    public var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Resources.Fonts.title2)
    }
}
