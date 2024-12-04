//
//  WorkspaceDTO.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/4/24.
//

import Foundation

public struct WorkspaceDTO: Decodable {
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

extension WorkspaceDTO {
    public func toStudyGroup() -> StudyGroup {
        return StudyGroup(groupId: self.workspaceId,
                          groupName: self.name,
                          groupDesc: self.description ?? "",
                          coverImage: self.coverImage,
                          ownerId: self.ownerId,
                          createdAt: self.createdAt)
    }
}
