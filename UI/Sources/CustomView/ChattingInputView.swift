//
//  ChattingInputView.swift
//  UI
//
//  Created by 김정윤 on 11/25/24.
//

import SwiftUI

public struct ChattingInputView: View {
    public init(_ text: Binding<String>, sendAction: @escaping () -> Void) {
        _text = text
        self.sendAction = sendAction
    }
    
    @Binding private var text: String
    @State private var height: CGFloat = 38
    private let sendAction: () -> Void
    
    private var sendButtonImage: Image {
        if text.isEmpty {
            return Resources.Images.icInActive
        } else {
            return Resources.Images.icActive
        }
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Resources.Corners.normal)
                .fill(Resources.Colors.bgPrimary)
                .frame(height: height)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .overlay {
                    HStack(alignment: .bottom, spacing: 8) {
                        Button {
                            print("plus")
                        } label: {
                            Resources.Images.plus
                                .resizable()
                                .frame(width: 22, height: 20)
                        }

                        TextField("", text: $text,
                                  prompt: Text("메시지를 입력하세요").foregroundStyle(Resources.Colors.textSecondary),
                                  axis: .vertical)
                            .frame(width: 275)
                            .offset(y: -2)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Resources.Fonts.body)
                            .foregroundStyle(Resources.Colors.textPrimary)
                            .onReadSize { size in
                                height = size.height + 22
                            }
                        
                        Button {
                            sendAction()
                        } label: {
                            sendButtonImage
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Resources.Colors.textSecondary)
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                }
        }
        .frame(maxWidth: .infinity)
    }
}
