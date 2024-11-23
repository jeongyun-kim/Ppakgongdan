//
//  String + Extension.swift
//  UI
//
//  Created by 김정윤 on 11/23/24.
//

import Foundation
import NetworkKit

extension String {
    var toURL: URL {
        let result = APIKey.baseURL.appending(path: "/v1\(self)")
        return result
    }
}
