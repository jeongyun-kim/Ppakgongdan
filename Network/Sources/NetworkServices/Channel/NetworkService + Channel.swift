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
    
    public func createNewChannel(workspaceId: String, name: String, desc: String?) async throws -> ChannelDTO {
        let query = CreateChannelQuery(name: name, description: desc)
        let result = await channelProvider.request(.createNewChannel(id: workspaceId, query: query))
        return try decodeResults(result, modelType: ChannelDTO.self)
    }
    
    public func getAllChannels(workspaceId: String) async throws -> [ChannelDTO] {
        let result = await channelProvider.request(.getAllChannels(id: workspaceId))
        return try decodeResults(result, modelType: [ChannelDTO].self)
    }
    
    public func getAllMyChannels(workspaceId: String) async throws -> [ChannelDTO] {
        let result = await channelProvider.request(.getAllMyChannels(id: workspaceId))
        return try decodeResults(result, modelType: [ChannelDTO].self)
    }
    
    public func getUnreadChannels(workspaceId: String, channelId: String, after: String) async throws -> UnreadChannelDTO {
        let query = UnreadChannelQuery(workspaceId: workspaceId, channelId: channelId, after: after)
        let result = await channelProvider.request(.getUnreadChannels(query))
        return try decodeResults(result, modelType: UnreadChannelDTO.self)
    }
    
    public func getChannelChats(workspaceId: String, channelId: String, after: String) async throws -> [ChannelChattingDTO] {
        let query = GetChannelChatsQuery(cursorDate: after, channelId: channelId, workspaceId: workspaceId)
        let result = await channelProvider.request(.getChannelChats(query))
        return try decodeResults(result, modelType: [ChannelChattingDTO].self)
    }
    
    public func postMyChat(workspaceId: String, channelId: String, content: String, files: [Data]) async throws -> ChannelChattingDTO {
        let query = MyChatQuery(channelId: channelId, workspaceId: workspaceId, content: content, files: files)
        let result = await channelProvider.request(.postMyChat(query))
        return try decodeResults(result, modelType: ChannelChattingDTO.self)
    }
}
