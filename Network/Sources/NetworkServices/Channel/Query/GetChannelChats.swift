//
//  GetChannelChats.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

struct GetChannelChats: Encodable {
    let cursor_date: String
    let channelId: String
    let workspaceId: String
}
