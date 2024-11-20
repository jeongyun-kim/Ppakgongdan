//
//  UnreadChannelQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/20/24.
//

import Foundation

public struct UnreadChannelQuery: Encodable {
    public init(workspaceId: String, channelId: String, after: String) {
        self.workspaceId = workspaceId
        self.channelId = channelId
        self.after = after
    }
    
    let workspaceId: String
    let channelId: String
    let after: String
}
