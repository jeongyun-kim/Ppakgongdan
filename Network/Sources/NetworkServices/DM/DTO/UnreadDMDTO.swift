//
//  UnreadDMDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/4/24.
//

import Foundation

public struct UnreadDMDTO: Decodable {
    public let channelId: String
    public let name: String
    public let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case count
    }
}
