//
//  WorkspaceDetail.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/15/24.
//

import Foundation

public struct WorkspaceDetailDTO: Decodable {
    public let workspaceId: String
    public let name: String
    public let description: String?
    public let coverImage: String?
    public let owenrId: String
    public let createdAt: String
    public let channels: [ChannelDTO]
    public let workspaceMembers: [MemberDTO]
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case owenrId = "owner_id"
        case createdAt
        case channels
        case workspaceMembers
    }
    
    public func toStudyGroupDetail() -> StudyGroupDetail {
        return StudyGroupDetail(workspaceId: self.workspaceId,
                                name: self.name,
                                description: self.description,
                                coverImage: self.coverImage,
                                owenrId: self.owenrId,
                                createdAt: self.createdAt)
    }
}

public struct ChannelDTO: Decodable {
    public let channelId: String
    public let name: String
    public let description: String?
    public let coverImage: String?
    public let ownerId: String
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
    
    public func toStudyGroupChannel() -> StudyGroupChannel {
        return StudyGroupChannel(channelId: self.channelId,
                                 name: self.name,
                                 description: self.description,
                                 coverImage: self.coverImage,
                                 ownerId: self.ownerId,
                                 createdAt: self.createdAt)
    }
}

public struct MemberDTO: Decodable {
    public let userId: String
    public let email: String
    public let nickname: String
    public let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
    }
    
    public func toStudyGroupMember() -> StudyGroupMember {
        return StudyGroupMember(userId: self.userId,
                                email: self.email,
                                nickname: self.nickname,
                                profileImage: self.profileImage)
    }
}
