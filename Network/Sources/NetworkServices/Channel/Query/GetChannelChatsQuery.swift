//
//  GetChannelChats.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation

struct GetChannelChatsQuery: Encodable {
    let cursorDate: String
    let channelId: String
    let workspaceId: String
}
