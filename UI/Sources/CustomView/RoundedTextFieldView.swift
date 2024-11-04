//
//  RoundedTextFieldView.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

public struct RoundedTextFieldView: View {
    private let placeHolder: String
    @Binding private var text: String
    
    public init(placeHolder: String, text: Binding<String>) {
        self.placeHolder = placeHolder
        _text = text
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Resources.Corners.normal)
                .fill(Resources.Colors.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            
            TextField(placeHolder, text: $text)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Resources.Colors.white)
                .font(Resources.Fonts.body)
                .padding(.horizontal, 12)
        }
        
    }
}
