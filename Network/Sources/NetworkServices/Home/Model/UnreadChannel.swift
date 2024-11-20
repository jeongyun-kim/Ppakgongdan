//
//  UnreadChannel.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/20/24.
//

import Foundation

public struct UnreadChannel: Decodable {
    let cahnelId: String
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case cahnelId = "channel_id"
        case name
        case count
    }
}
