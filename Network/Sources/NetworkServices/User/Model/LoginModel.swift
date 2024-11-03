//
//  LoginModel.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation

public struct LoginModel: Decodable {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String
    let createdAt: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case createdAt
        case token
    }
}

public struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}
