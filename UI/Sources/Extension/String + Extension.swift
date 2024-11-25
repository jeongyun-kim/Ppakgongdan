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
    
    public func toChattingDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else {
            return ""
        }
    
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "hh:mm a"
        
        return timeFormatter.string(from: date)
    }
}
