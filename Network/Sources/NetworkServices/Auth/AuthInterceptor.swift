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
        print(#function)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) async {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 400 else {
            completion(.doNotRetry)
            return
        }
    
        do {
            let result = try await NetworkService.shared.refreshToken()
            UserDefaultsManager.shared.accessToken = result.accessToken
            completion(.retry)
            print(#function, "success")
        } catch {
            completion(.doNotRetryWithError(error))
            print(#function, "fail")
            UserDefaultsManager.shared.deleteAllData()
        }
    }
}
