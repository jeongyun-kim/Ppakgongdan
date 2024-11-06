//
//  HomeRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/4/24.
//

import Foundation
import Moya
import Utils

enum HomeRouter {
    case getMyWorkspaces
}

extension HomeRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case.getMyWorkspaces:
            return "/v1/workspaces"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyWorkspaces:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyWorkspaces:
            return .requestPlain // 보낼 데이터 없을 때 사용 
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
