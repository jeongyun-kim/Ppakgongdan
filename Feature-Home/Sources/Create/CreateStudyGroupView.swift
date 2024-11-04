//
//  CreateStudyGroupView.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/4/24.
//

import SwiftUI
import UI

public struct CreateStudyGroupView: View {
    public init() { }
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    customDivider()
                    Spacer()
                }
            }
            .navigationBarForPresent(title: "스터디그룹 생성")
        }
    }
}
