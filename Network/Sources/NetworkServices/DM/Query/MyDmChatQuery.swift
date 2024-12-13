//
//  MyDmChatQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/12/24.
//

import Foundation

struct MyDmChatQuery: Decodable {
    let roomId: String
    let workspaceId: String
    let content: String
    let files: [Data] = []
}
