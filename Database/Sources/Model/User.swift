//
//  User.swift
//  Database
//
//  Created by 김정윤 on 11/28/24.
//

import Foundation
import RealmSwift

public class User: Object, ObjectKeyIdentifiable {
    convenience init(id: String, email: String, nickname: String, profileImage: String? = nil) {
        self.init()
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }

    @Persisted(primaryKey: true) public var id: String
    @Persisted public var email: String
    @Persisted public var nickname: String
    @Persisted public var profileImage: String?
}
