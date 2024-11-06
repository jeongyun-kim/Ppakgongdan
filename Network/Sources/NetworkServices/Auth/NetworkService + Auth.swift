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
    
    public func getRefreshToken(completionHandler: @escaping(Result<RefreshTokenModel, ErrorCodes>) -> Void) {
        authProvider.request(.refreshToken) { result in
            switch result {
            case .success(let value):
                print(value.statusCode)
                do {
                    let result = try JSONDecoder().decode(RefreshTokenModel.self, from: value.data)
                    completionHandler(.success(result))
                } catch {
                    print("Error")
                    let result = try? JSONDecoder().decode(ErrorModel.self, from: value.data)
                    print("ㄹㅇㄹㅇ", result)
                }
            case .failure(let error):
                print("getRefreshError", error)
                completionHandler(.failure(.E06))
            }
        }
    }
}
