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
    case appleLogin(query: AppleLoginQuery)
    case emailLogin(query: EmailLoginQuery)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .emailLogin:
            return "/v1/users/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        case .appleLogin:
            return .post
        case .emailLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let query):
            return .requestJSONEncodable(query)
        case .appleLogin(let query):
            return .requestJSONEncodable(query)
        case .emailLogin(let query):
            return .requestJSONEncodable(query)
        }
    }
    
    var headers: [String : String]? {
        return [APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}


