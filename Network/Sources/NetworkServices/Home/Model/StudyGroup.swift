//
//  Workspace.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/4/24.
//

import Foundation

public struct StudyGroup: Equatable {
    public init(groupId: String, groupName: String, groupDesc: String, coverImage: String, ownerId: String, createdAt: String) {
        self.groupId = groupId
        self.groupName = groupName
        self.groupDesc = groupDesc
        self.coverImage = coverImage
        self.ownerId = ownerId
        self.createdAt = createdAt
    }
    
    public let groupId: String
    public let groupName: String
    public let groupDesc: String
    public let coverImage: String
    public let ownerId: String
    public let createdAt: String
}

