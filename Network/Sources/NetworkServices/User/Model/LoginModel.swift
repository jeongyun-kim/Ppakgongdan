//
//  LoginModel.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation

public struct LoginModel: Decodable {
    public let userId: String
    public let email: String
    public let nickname: String
    public let profileImage: String?
    public let phone: String?
    let provider: String?
    public let createdAt: String
    public let token: Token
    
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
    public let accessToken: String
    public let refreshToken: String
}
