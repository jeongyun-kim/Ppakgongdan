//
//  NetworkService + Auth.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/5/24.
//

import Foundation
import Moya

extension NetworkService {
    var authProvider: MoyaProvider<AuthRouter> {
        return MoyaProvider<AuthRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func refreshToken() async throws -> RefreshTokenModel {
        let result = await authProvider.request(.refreshToken)
        return try decodeResults(result, modelType: RefreshTokenModel.self)
    }
}
