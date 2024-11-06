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
}
