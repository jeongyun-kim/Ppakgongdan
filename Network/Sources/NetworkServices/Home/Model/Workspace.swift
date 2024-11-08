//
//  Workspace.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/4/24.
//

import Foundation

public struct Workspace: Decodable {
    public let workspaceId: String
    public let name: String
    public let description: String?
    public let coverImage: String
    public let ownerId: String
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
}

extension Workspace {
    public func toStudyGroup() -> StudyGroup {
        return StudyGroup(groupId: self.workspaceId,
                          groupName: self.name,
                          groupDesc: self.description ?? "",
                          coverImage: self.coverImage,
                          ownerId: self.ownerId,
                          createdAt: self.createdAt)
    }
}

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

