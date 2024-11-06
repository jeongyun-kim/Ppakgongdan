//
//  AuthRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 10/29/24.
//

import Foundation
import Utils
import Moya

enum AuthRouter {
    case refreshToken
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        return "/v1/auth/refresh"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [
            APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json,
            APIKey.auth: UserDefaultsManager.shared.accessToken,
            "RefreshToken": UserDefaultsManager.shared.refreshToken
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

