//
//  UserDefaultsManager.swift
//  Ppakgongdan
//
//  Created by 김정윤 on 11/1/24.
//

import Foundation

public class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    public init() { }
    
    @propertyWrapper struct UD<T> {
        var key: String
        var defaultValue: T
        
        public init(key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T {
            get {
                UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }

    @UD(key: UDKey.deviceToken.rawValue, defaultValue: "") public var deviceToken
    @UD(key: UDKey.accessToken.rawValue, defaultValue: "") public var accessToken
    @UD(key: UDKey.refreshToken.rawValue, defaultValue: "") public var refreshToken
    @UD(key: UDKey.isUser.rawValue, defaultValue: false) public var isUser
    @UD(key: UDKey.isApple.rawValue, defaultValue: false) public var isApple
    @UD(key: UDKey.isKakao.rawValue, defaultValue: false) public var isKakao
    @UD(key: UDKey.email.rawValue, defaultValue: "") public var email
    @UD(key: UDKey.recentGroupId.rawValue, defaultValue: "") public var recentGroupId
    
    public func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
