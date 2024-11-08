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

extension NetworkService {
    var homeProvider: MoyaProvider<HomeRouter> {
        return MoyaProvider<HomeRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func getMyWorkspaces() async throws -> [Workspace] {
        let result = await homeProvider.request(.getMyWorkspaces)
        return try decodeResults(result, modelType: [Workspace].self)
    }
    
    public func createWorkspace(name: String, desc: String, image: Data) async throws -> Workspace {
        print(#function)
        let query = CreateWorkSpace(name: name, description: desc, image: image)
        let result = await homeProvider.request(.createWorkspace(query))
        return try decodeResults(result, modelType: Workspace.self)
    }
}
