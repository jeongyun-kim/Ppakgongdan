//
//  CreateChannelQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/21/24.
//

import Foundation

struct CreateChannelQuery: Encodable {
    let name: String
    let description: String?
}
