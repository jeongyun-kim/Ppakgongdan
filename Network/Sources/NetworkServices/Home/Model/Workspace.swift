//
//  Workspace.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/4/24.
//

import Foundation

public struct Workspace: Decodable {
    let workspaceId: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
}
