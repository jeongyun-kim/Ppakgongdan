//
//  EmailLoginQuery.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/1/24.
//

import Foundation

struct EmailLoginQuery: Encodable {
    let email: String
    let password: String
    let deviceToken: String = ""
}
