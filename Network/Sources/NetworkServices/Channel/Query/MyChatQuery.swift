//
//  MyChatQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

struct MyChatQuery: Encodable {
    let channelId: String
    let workspaceId: String
    let content: String
    let files: [Data]
}
