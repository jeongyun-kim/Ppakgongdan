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
        return MoyaProvider<UserRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public typealias Model = LoginDTO
    
    // 카카오 로그인 - 비동기 작업 + 에러 던질거라고 명시
    public func postKakaoLogin(_ query: KakaoLoginQuery) async throws -> Model {
        let request = await userProvider.request(.kakaoLogin(query: query))
        return try decodeResults(request, modelType: Model.self)
    }
    
    // 애플 로그인
    public func postAppleLogin(_ query: AppleLoginQuery) async throws -> Model {
        let request = await userProvider.request(.appleLogin(query: query))
        return try decodeResults(request, modelType: Model.self)
    }
    
    public func postEmailLogin(email: String, passworkd: String) async throws -> Model {
        let query = EmailLoginQuery(email: email, password: passworkd)
        let result = await userProvider.request(.emailLogin(query: query))
        return try decodeResults(result, modelType: Model.self)
    }
}


