//
//  View + Extension.swift
//  UI
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI

// MARK: 뷰 눌러서 키보드 내리기
extension View {
    public func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: 뷰 크기 측정
extension View {
  @ViewBuilder
  public func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
    self.customBackground {
      GeometryReader { geometry in
        // 뷰의 크기를 알기 위해 투명 배경을 통해 사이즈 측정
        Color.clear
              .preference(key: SizePreferenceKey.self, value: geometry.size)
      }
    }
      // Preference Key가 변경될 때마다 클로저로 크기 정보 전달
    .onPreferenceChange(SizePreferenceKey.self, perform: perform)
  }
  
  @ViewBuilder
  func customBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
    // 뷰의 백그라운드와 같은 역할
      self.background(alignment: alignment, content: content)
  }
}

// PreferenceKey 채택 통해 뷰 계층 내 값 공유 가능
struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
