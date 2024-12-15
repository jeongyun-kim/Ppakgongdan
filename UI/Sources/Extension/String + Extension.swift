//
//  String + Extension.swift
//  UI
//
//  Created by 김정윤 on 11/23/24.
//

import Foundation
import NetworkKit

extension String {
    private var format: String {
        return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    var toURL: URL {
        let result = APIKey.baseURL.appending(path: "/v1\(self)")
        return result
    }
    
    public var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    public func toSideMenuDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    public func toChattingDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return "" }
  
        // 만약 비교하는 날짜가 오늘이라면
        if date.isToday {
            dateFormatter.dateFormat = "hh:mm a"
        } else { // 비교하는 날짜가 오늘이 아니라면
            dateFormatter.dateFormat = "M/d hh:mm a"
        }

        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    public func toDmListDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return "" }
    
        // 만약 비교하는 날짜가 오늘이 아니라면
        if date.isToday {
            dateFormatter.dateFormat = "hh:mm a"
        } else { // 비교하는 날짜가 오늘이라면
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        }

        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
