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
    
    public func getDmList(workspaceId: String) async throws -> [DMDTO] {
        let result = await dmProvider.request(.getDmList(id: workspaceId))
        return try decodeResults(result, modelType: [DMDTO].self)
    }
    
    public func getUnreadDms(workspaceId: String, roomlId: String, after: String) async throws -> UnreadDMDTO {
        let query = UnreadDmQuery(roomId: roomlId, workspaceId: workspaceId, after: after)
        let result = await dmProvider.request(.getUnreadDms(query))
        return try decodeResults(result, modelType: UnreadDMDTO.self)
    }
}
