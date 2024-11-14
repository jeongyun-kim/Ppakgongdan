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
    func getMyWorkspaces() async throws -> [Workspace]
    func createWorkspace(name: String, desc: String, image: Data) async throws -> Workspace
    func deleteWorkspace(groupId: String) async throws
    func exitWorkspace(groupId: String) async throws -> [Workspace]
}
