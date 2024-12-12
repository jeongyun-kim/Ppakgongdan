//
//  UnreadDMDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/4/24.
//

import Foundation

public struct UnreadDmDTO: Decodable {
    public let roomlId: String
    public let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomlId = "room_id"
        case count
    }
}
