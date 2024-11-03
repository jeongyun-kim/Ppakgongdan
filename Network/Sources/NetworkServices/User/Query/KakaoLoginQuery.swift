//
//  KakaoLoginQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation

public struct KakaoLoginQuery: Encodable {
    public var oauthToken: String
    public var deviceToken: String
    
    public init(oauthToken: String, deviceToken: String) {
        self.oauthToken = oauthToken
        self.deviceToken = deviceToken
    }
}
