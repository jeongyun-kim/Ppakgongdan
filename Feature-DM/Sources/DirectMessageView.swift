//
//  DirectMessageView.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/9/24.
//

import SwiftUI
import UI
import ComposableArchitecture

public struct DirectMessageView: View {
    public init(store: StoreOf<DirectMessageReducer>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<DirectMessageReducer>
    
    public var body: some View {
        Text("dm")
    }
}
