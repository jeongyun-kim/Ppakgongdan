//
//  View + Extension.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

extension View {
    // 뷰 눌러서 키보드 내리기 
    public func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
