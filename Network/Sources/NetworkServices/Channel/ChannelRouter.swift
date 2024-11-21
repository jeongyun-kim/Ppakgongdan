//
//  ChannelRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/21/24.
//

import Foundation
import Moya
import Utils

enum ChannelRouter {
    case createNewChannel(id: String, query: CreateChannelQuery)
    case getAllChannels(id: String)
    case getAllMyChannels(id: String)
}

extension ChannelRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case .createNewChannel(let id, _):
            return "/v1/workspaces/\(id)/channels"
        case .getAllChannels(let id):
            return "/v1/workspaces/\(id)/channels"
        case .getAllMyChannels(let id):
            return "/v1/workspaces/\(id)/my-channels"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createNewChannel:
            return .post
        case .getAllChannels:
            return .get
        case .getAllMyChannels:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createNewChannel(_, let query):
            return .requestJSONEncodable(query)
        case .getAllChannels:
            return .requestPlain
        case .getAllMyChannels:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json,
            APIKey.auth: UserDefaultsManager.shared.accessToken
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
