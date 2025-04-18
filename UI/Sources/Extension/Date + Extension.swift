//
//  Date + Extension.swift
//  UI
//
//  Created by 김정윤 on 12/1/24.
//

import Foundation

extension Date {
    var isToday: Bool {
        let dateString = self.formatted(date: .numeric, time: .omitted)
        let todayString = Date().formatted(date: .numeric, time: .omitted)
        return dateString == todayString
    }
    
    public func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
