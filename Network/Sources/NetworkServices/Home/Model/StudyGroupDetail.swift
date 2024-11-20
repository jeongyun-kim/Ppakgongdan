//
//  StudyGroupDetail.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/16/24.
//

import Foundation

public struct StudyGroupDetail: Equatable {
    public init(workspaceId: String, name: String, description: String?, coverImage: String?, owenrId: String, createdAt: String) {
        self.workspaceId = workspaceId
        self.name = name
        self.description = description
        self.coverImage = coverImage
        self.owenrId = owenrId
        self.createdAt = createdAt
    }
    
    public let workspaceId: String
    public let name: String
    public let description: String?
    public let coverImage: String?
    public let owenrId: String
    public let createdAt: String
}

public struct StudyGroupChannel: Equatable {
    public init(channelId: String, name: String, description: String?, coverImage: String?, ownerId: String, createdAt: String) {
        self.channelId = channelId
        self.name = name
        self.description = description
        self.coverImage = coverImage
        self.ownerId = ownerId
        self.createdAt = createdAt
        self.unreadCount = 0
        self.currentReadDate = createdAt
    }
    
    public let channelId: String
    public let name: String
    public let description: String?
    public let coverImage: String?
    public let ownerId: String
    public let createdAt: String
    public var unreadCount: Int
    public var currentReadDate: String
}

public struct StudyGroupMember: Equatable {
    public init(userId: String, email: String, nickname: String, profileImage: String?) {
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
    public let userId: String
    public let email: String
    public let nickname: String
    public let profileImage: String?
}
