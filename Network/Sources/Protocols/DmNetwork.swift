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
    func getDmList(workspaceId: String) async throws -> [DMDTO]
    func getUnreadDms(workspaceId: String, roomlId: String, after: String) async throws -> UnreadDMDTO
    func getDmChattings(workspaceId: String, roomId: String, after: String) async throws -> [DmChattingDTO]
}

