//
//  UserRouter.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import Moya

enum UserRouter {
    case kakaoLogin(query: KakaoLoginQuery)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin(let query):
            return "/v1/users/login/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin(let query):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let query):
            return .requestJSONEncodable(query)
        }
    }
    
    var headers: [String : String]? {
        return [APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json]
    }
}


