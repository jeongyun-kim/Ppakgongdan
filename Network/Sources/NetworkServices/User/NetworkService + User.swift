//
//  NetworkService + User.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import Moya

extension NetworkService: UserNetwork {
    var userProvider: MoyaProvider<UserRouter> {
        return MoyaProvider<UserRouter>()
    }

    // 비동기 작업 + 에러 던질거라고 명시
    public func postKakaoLogin(_ query: KakaoLoginQuery) async throws -> LoginModel {
        let request = await userProvider.request(.kakaoLogin(query: query))
        return try decodeResults(request, modelType: LoginModel.self)
    }
}


