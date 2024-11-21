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
}
