//
//  DmRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/9/24.
//

import Foundation
import Utils
import Moya

enum DmRouter {
    case getAllMembers(id: String)
    case getDmList(id: String)
    case getUnreadDms(UnreadDmQuery)
    case getDmChattings(DmChattingQuery)
}

extension DmRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case .getAllMembers(let id):
            return "/v1/workspaces/\(id)/members"
        case .getDmList(let id):
            return "/v1/workspaces/\(id)/dms"
        case .getUnreadDms(let query):
            return "/v1/workspaces/\(query.workspaceId)/dms/\(query.roomId)/unreads"
        case .getDmChattings(let query):
            return "/v1/workspaces/\(query.workspaceId)/dms/\(query.roomId)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllMembers:
            return .get
        case .getDmList:
            return .get
        case .getUnreadDms:
            return .get
        case .getDmChattings:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllMembers:
            return .requestPlain
        case .getDmList:
            return .requestPlain
        case .getUnreadDms:
            return .requestPlain
        case .getDmChattings(let query):
            return .requestParameters(parameters: ["cursor_date": query.cursorDate], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json,
            APIKey.auth: UserDefaultsManager.shared.accessToken,
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
