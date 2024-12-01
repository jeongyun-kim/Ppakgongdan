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
    
    public var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    public func toChattingDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        let dateString = date.formatted(date: .numeric, time: .omitted)
        let todayString = Date().formatted(date: .numeric, time: .omitted)
        
        // 만약 비교하는 날짜가 오늘이 아니라면
        if dateString == todayString {
            dateFormatter.dateFormat = "hh:mm a"
        } else { // 비교하는 날짜가 오늘이라면
            dateFormatter.dateFormat = "M/d HH:mm a"
        }

        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
