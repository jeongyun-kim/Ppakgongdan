//
//  NetworkService + DM.swift
//  NetworkKit
//
//  Created by 김정윤 on 12/9/24.
//

import Foundation
import Moya

extension NetworkService: DmNetwork {
    var dmProvider: Moya.MoyaProvider<DmRouter> {
        return MoyaProvider<DmRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func getAllMembers(id: String) async throws -> [MemberDTO] {
        let result = await dmProvider.request(.getAllMembers(id: id))
        return try decodeResults(result, modelType: [MemberDTO].self)
    }
    
    public func getDmList(workspaceId: String) async throws -> [DmDTO] {
        let result = await dmProvider.request(.getDmList(id: workspaceId))
        return try decodeResults(result, modelType: [DmDTO].self)
    }
    
    public func getUnreadDms(workspaceId: String, roomlId: String, after: String) async throws -> UnreadDmDTO {
        let query = UnreadDmQuery(roomId: roomlId, workspaceId: workspaceId, after: after)
        let result = await dmProvider.request(.getUnreadDms(query))
        return try decodeResults(result, modelType: UnreadDmDTO.self)
    }
    
    public func getDmChattings(workspaceId: String, roomId: String, after: String) async throws -> [DmChattingDTO] {
        let query = DmChattingQuery(roomId: roomId, workspaceId: workspaceId, cursorDate: after)
        let result = await dmProvider.request(.getDmChattings(query))
        return try decodeResults(result, modelType: [DmChattingDTO].self)
    }
    
    public func createDmChatRoom(workspaceId: String, opponentId: String) async throws -> DmDTO {
        let query = CreateDmChatRoomQuery(opponent_id: opponentId)
        let result = await dmProvider.request(.createDmChatRoom(groupId: workspaceId, query))
        return try decodeResults(result, modelType: DmDTO.self)
    }
    
    public func sendDmChat(workspaceId: String, roomId: String, message: String) async throws -> DmChattingDTO {
        let query = MyDmChatQuery(roomId: roomId, workspaceId: workspaceId, content: message)
        let result = await dmProvider.request(.sendMyDmChat(query))
        return try decodeResults(result, modelType: DmChattingDTO.self)
    }
}
