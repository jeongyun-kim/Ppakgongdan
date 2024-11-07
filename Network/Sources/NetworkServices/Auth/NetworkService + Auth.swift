//
//  NetworkService + Auth.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/5/24.
//

import Foundation
import Moya
import Utils

extension NetworkService {
    var authProvider: MoyaProvider<AuthRouter> {
        return MoyaProvider<AuthRouter>()
    }
    
    public func getRefreshToken(completionHandler: @escaping(Result<RefreshTokenModel, ErrorCodes>) -> Void) {
        authProvider.request(.refreshToken) { result in
            switch result {
            case .success(let value):
                let decodedResult = try? JSONDecoder().decode(RefreshTokenModel.self, from: value.data)
                guard let decodedResult else { return }
                completionHandler(.success(decodedResult))
            case .failure(let error):
                let statusCode = ErrorStates.allCases.filter{ $0.rawValue == error.response?.statusCode }[0]
                switch statusCode {
                case .fail:
                    guard let errorData = error.response?.data else { return }
                    let error = try? JSONDecoder().decode(ErrorModel.self, from: errorData)
                    guard let error else { return }
                    let errorCode = ErrorCodes.allCases.filter { $0.rawValue == error.errorCode }[0]
                    completionHandler(.failure(errorCode))
                case .serverError:
                    completionHandler(.failure(.E99))
                }
            }
        }
    }
}
