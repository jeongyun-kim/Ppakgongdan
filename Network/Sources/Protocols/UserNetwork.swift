//
//  UserNetwork.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import Moya

protocol UserNetwork {
    var userProvider: MoyaProvider<UserRouter> { get }
    func postKakaoLogin(_ query: KakaoLoginQuery) async throws -> LoginModel
    func postAppleLogin(_ query: AppleLoginQuery) async throws -> LoginModel
    func postEmailLogin(email: String, passworkd: String) async throws -> LoginModel
}
