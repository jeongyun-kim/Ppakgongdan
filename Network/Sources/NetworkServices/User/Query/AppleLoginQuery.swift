//
//  AppleLoginQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation

public struct AppleLoginQuery: Encodable {
    let idToken: String
    let nickname: String
    let deviceToken: String
    
    public init(idToken: String, nickname: String, deviceToken: String) {
        self.idToken = idToken
        self.nickname = nickname
        self.deviceToken = deviceToken
    }
}
