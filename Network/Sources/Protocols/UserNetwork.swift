//
//  UserNetwork.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation
import Moya

protocol UserNetwork {
    typealias model = LoginDTO
    
    var userProvider: MoyaProvider<UserRouter> { get }
    func postKakaoLogin(_ query: KakaoLoginQuery) async throws -> model
    func postAppleLogin(_ query: AppleLoginQuery) async throws -> model
    func postEmailLogin(email: String, passworkd: String) async throws -> model
}
