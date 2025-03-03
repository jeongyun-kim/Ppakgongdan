//
//  DmNetwork.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/9/24.
//

import Foundation
import Moya

protocol DmNetwork {
    var dmProvider: MoyaProvider<DmRouter> { get }
    func getDmList(workspaceId: String) async throws -> [DmDTO]
    func getUnreadDms(workspaceId: String, roomlId: String, after: String) async throws -> UnreadDmDTO
    func getDmChattings(workspaceId: String, roomId: String, after: String) async throws -> [DmChattingDTO]
    func createDmChatRoom(workspaceId: String, opponentId: String) async throws -> DmDTO
    func sendDmChat(workspaceId: String, roomId: String, message: String) async throws -> DmChattingDTO
}

