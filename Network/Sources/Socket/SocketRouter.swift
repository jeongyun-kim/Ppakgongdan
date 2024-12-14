//
//  SocketRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/14/24.
//

import Foundation

public enum SocketRouter {
    case channel(id: String)
    case dm(id: String)
    
    var eventName: String {
        switch self {
        case .channel:
            return "channel"
        case .dm:
            return "dm"
        }
    }
    
    var path: String {
        switch self {
        case .channel(let id):
            return "/ws-channel-\(id)"
        case .dm(let id):
            return "/ws-dm-\(id)"
        }
    }
}
