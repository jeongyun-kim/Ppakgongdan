//
//  ChannelNetwork.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/21/24.
//

import Foundation
import Moya

protocol ChannelNetwork {
    var channelProvider: MoyaProvider<ChannelRouter> { get }
    func createNewChannel(workspaceId: String, name: String, desc: String?) async throws -> Channel
    func getAllChannels(workspaceId: String) async throws -> [Channel]
    func getAllMyChannels(workspaceId: String) async throws -> [Channel]
    func getUnreadChannels(workspaceId: String, channelId: String, after: String) async throws -> UnreadChannelDTO
    func getChannelChats(workspaceId: String, channelId: String, after: String) async throws -> [ChannelChattingDTO]
    func postMyChat(workspaceId: String, channelId: String, content: String, files: [Data]) async throws -> ChannelChattingDTO
}
