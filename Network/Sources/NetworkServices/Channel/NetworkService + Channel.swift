//
//  NetworkService + Channel.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/21/24.
//

import Foundation
import Moya

extension NetworkService: ChannelNetwork {
    var channelProvider: Moya.MoyaProvider<ChannelRouter> {
        return MoyaProvider<ChannelRouter>(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func createNewChannel(workspaceId: String, name: String, desc: String?) async throws -> Channel {
        let query = CreateChannelQuery(name: name, description: desc)
        let result = await channelProvider.request(.createNewChannel(id: workspaceId, query: query))
        return try decodeResults(result, modelType: Channel.self)
    }
    
    public func getAllChannels(workspaceId: String) async throws -> [Channel] {
        let result = await channelProvider.request(.getAllChannels(id: workspaceId))
        return try decodeResults(result, modelType: [Channel].self)
    }
    
    public func getAllMyChannels(workspaceId: String) async throws -> [Channel] {
        let result = await channelProvider.request(.getAllMyChannels(id: workspaceId))
        return try decodeResults(result, modelType: [Channel].self)
    }
}
