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
    case deleteWorkspace(id: String)
    case exitWorkspace(id: String)
    case getWorkspaceDetail(id: String)
    case inviteWorkspaceMemeber(id: String, query: InviteMemberQuery)
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
        case .deleteWorkspace(let id):
            return  "/v1/workspaces/\(id)"
        case .exitWorkspace(let id):
            return "/v1/workspaces/\(id)/exit"
        case .getWorkspaceDetail(let id):
            return "/v1/workspaces/\(id)"
        case .inviteWorkspaceMemeber(let id, _):
            return "/v1/workspaces/\(id)/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyWorkspaces:
            return .get
        case .createWorkspace:
            return .post
        case .deleteWorkspace:
            return .delete
        case .exitWorkspace:
            return .get
        case .getWorkspaceDetail:
            return .get
        case .inviteWorkspaceMemeber:
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
                MultipartFormData(provider: .data(query.image), name: "image", fileName: "\(query.name).jpeg", mimeType: "image/jpeg"),
                MultipartFormData(provider: .data(query.description.data(using: .utf8)!), name: "description")
            ])
        case .deleteWorkspace:
            return .requestPlain
        case .exitWorkspace:
            return .requestPlain
        case .getWorkspaceDetail:
            return .requestPlain
        case .inviteWorkspaceMemeber(_, let query):
            return .requestJSONEncodable(query)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createWorkspace:
            return [
                APIKey.headerKey: APIKey.key, APIKey.content: APIKey.formData,
                APIKey.auth: UserDefaultsManager.shared.accessToken
            ]
        default:
            return [
                APIKey.headerKey: APIKey.key, APIKey.content: APIKey.json,
                APIKey.auth: UserDefaultsManager.shared.accessToken
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
