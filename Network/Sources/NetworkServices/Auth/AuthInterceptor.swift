//
//  AuthInterceptor.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/5/24.
//

import Alamofire
import Moya
import Utils
import Foundation

final class AuthInterceptor: RequestInterceptor {
    private init() { }
    static let shared = AuthInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        request.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: APIKey.auth)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard response.statusCode == 400 else {
            completion(.doNotRetry)
            return
        }

        NetworkService.shared.getRefreshToken { result in
            switch result {
            case .success(let value):
                UserDefaultsManager.shared.accessToken = value.accessToken
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
