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

    @UD(key: "accessToken", defaultValue: "") public var accessToken
    @UD(key: "refreshToken", defaultValue: "") public var refreshToken
    @UD(key: "isUser", defaultValue: false) public var isUser
    @UD(key: "isApple", defaultValue: false) public var isApple
    @UD(key: "isKakao", defaultValue: false) public var isKakao
    @UD(key: "email", defaultValue: "") public var email
    
    func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
