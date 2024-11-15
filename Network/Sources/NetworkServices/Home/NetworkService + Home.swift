//
//  NetworkService + Home.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/4/24.
//

import Foundation
import Moya
import Alamofire
import Utils

extension NetworkService: HomeNetwork {
    var homeProvider: MoyaProvider<HomeRouter> {
        return MoyaProvider<HomeRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func getMyWorkspaces() async throws -> [Workspace] {
        let result = await homeProvider.request(.getMyWorkspaces)
        return try decodeResults(result, modelType: [Workspace].self)
    }
    
    public func createWorkspace(name: String, desc: String, image: Data) async throws -> Workspace {
        let query = CreateWorkSpace(name: name, description: desc, image: image)
        let result = await homeProvider.request(.createWorkspace(query))
        return try decodeResults(result, modelType: Workspace.self)
    }
    
    public func deleteWorkspace(groupId: String) async throws {
        let result = await homeProvider.request(.deleteWorkspace(id: groupId))
        switch result {
        case .success(_):
            print("🔴 Deleted StudyGroup Successful!")
        case .failure(let error):
            guard let statusCode = error.response?.statusCode else { throw ErrorCodes.E00 }
            let errorState = ErrorStates.allCases.filter { $0.rawValue == statusCode }[0]
            switch errorState {
            case .fail:
                guard let errorData = error.response?.data else { throw ErrorCodes.E00 }
                let errorResult = try? JSONDecoder().decode(ErrorModel.self, from: errorData)
                guard let errorResult else { throw ErrorCodes.E00 }
                let errorCode = ErrorCodes.allCases.filter { $0.rawValue == errorResult.errorCode }[0]
                throw errorCode
            case .serverError:
                throw ErrorCodes.E99
            }
        }
    }
    
    public func exitWorkspace(groupId: String) async throws -> [Workspace] {
        let result = await homeProvider.request(.exitWorkspace(id: groupId))
        return try decodeResults(result, modelType: [Workspace].self)
    }
    
    public func getWorkspaceDetail(workspaceId: String) async throws -> WorkspaceDetail {
        let result = await homeProvider.request(.getWorkspaceDetail(id: workspaceId))
        return try decodeResults(result, modelType: WorkspaceDetail.self)
    }
}
