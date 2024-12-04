//
//  HomeNetwork.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/13/24.
//

import Foundation
import Moya

protocol HomeNetwork {
    var homeProvider: MoyaProvider<HomeRouter> { get }
    func getMyWorkspaces() async throws -> [WorkspaceDTO]
    func createWorkspace(name: String, desc: String, image: Data) async throws -> WorkspaceDTO
    func deleteWorkspace(groupId: String) async throws
    func exitWorkspace(groupId: String) async throws -> [WorkspaceDTO]
    func getWorkspaceDetail(workspaceId: String) async throws -> WorkspaceDetailDTO
    func getDmList(workspaceId: String) async throws -> [DMDTO]
    func getUnreadDms(workspaceId: String, roomlId: String, after: String) async throws -> UnreadDMDTO
    func inviteWorkspaceMemeber(workspaceId: String, email: String) async throws -> MemberDTO
}
