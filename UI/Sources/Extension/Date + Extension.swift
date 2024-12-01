//
//  Date + Extension.swift
//  UI
//
//  Created by 김정윤 on 12/1/24.
//

import Foundation

extension Date {
    public func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
