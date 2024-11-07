//
//  NetworkService.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import Moya

public class NetworkService {
    private init() { }
    public static let shared = NetworkService()
    
    enum ErrorStates: Int, CaseIterable {
        case fail = 400
        case serverError = 500
    }
    
    // Moya를 통한 네트워크 통신 결과 받아와서 각 모델, 에러에 맞게 분기처리
    // - 성공 시, 모델 반환
    // - 실패 시, 에러 코드 반환
    func decodeResults<T: Decodable>(_ results: Result<Response, MoyaError>, modelType: T.Type) throws -> T {
        switch results {
        case .success(let value):
            return try JSONDecoder().decode(T.self, from: value.data)
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
}
