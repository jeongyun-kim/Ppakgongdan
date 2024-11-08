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
    case createWorkspace(CreateWorkSpace)
}

extension HomeRouter: TargetType {
    var baseURL: URL {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case .getMyWorkspaces:
            return "/v1/workspaces"
        case .createWorkspace:
            return "/v1/workspaces"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyWorkspaces:
            return .get
        case .createWorkspace:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyWorkspaces:
            return .requestPlain // 보낼 데이터 없을 때 사용
        case .createWorkspace(let query):
            return .uploadMultipart([
                MultipartFormData(provider: .data(query.name.data(using: .utf8)!), name: "name"),
                MultipartFormData(provider: .data(query.image.base64EncodedData()), name: "image", fileName: "\(query.name).jpeg", mimeType: "image/jpeg"),
                MultipartFormData(provider: .data(query.description.data(using: .utf8)!), name: "description")
            ])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMyWorkspaces:
            return [
                APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json,
                APIKey.auth: UserDefaultsManager.shared.accessToken
            ]
        case .createWorkspace(let createWorkSpace):
            return [
                APIKey.headerKey: APIKey.key, APIKey.content: APIKey.formData,
                APIKey.auth: UserDefaultsManager.shared.accessToken
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
