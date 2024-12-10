//
//  DmChattingQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/10/24.
//

import Foundation

struct DmChattingQuery: Encodable {
    let roomId: String
    let workspaceId: String
    let cursorDate: String
}
