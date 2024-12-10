//
//  UnreadDmQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/20/24.
//

import Foundation

struct UnreadDmQuery: Encodable {
    let roomId: String
    let workspaceId: String
    let after: String
}
