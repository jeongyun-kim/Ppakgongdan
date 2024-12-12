//
//  DirectMessageReducer.swift
//  Feature-DM
//
//  Created by 김정윤 on 12/9/24.
//

import NetworkKit
import Utils
import ComposableArchitecture

@Reducer
public struct DirectMessageReducer {
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.directMessageReducerState = DirectMessageChattingReducer.State()
        }
        var memberList: [StudyGroupMember] = []
        var dmList: [DmChatting] = []
        var directMessageReducerState: DirectMessageChattingReducer.State
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case directMessageReducerAction(DirectMessageChattingReducer.Action)
        case viewOnAppear
        case getAllMembers
        case setAllMembers([MemberDTO])
        case getDmList
        case getUnreadDmCounts([DmDTO])
        case getDmChattings([DirectMessage])
        case setDmChattings([DmChattingDTO])
        case createDmChatRoom(String)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.directMessageReducerState, action: \.directMessageReducerAction) {
            DirectMessageChattingReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .viewOnAppear:
                return .merge(
                    .send(.getAllMembers),
                    .send(.getDmList)
                )
                
            case .getAllMembers:
                return .run { [id = UserDefaultsManager.shared.recentGroupId] send in
                    do {
                        let result = try await NetworkService.shared.getAllMembers(id: id)
                        await send(.setAllMembers(result))
                    } catch {
                        print("1", error)
                    }
                }
                
            case .setAllMembers(let list):
                state.memberList = list.filter { $0.userId != UserDefaultsManager.shared.userId }.map { $0.toStudyGroupMember() }
                return .none
                
            case .getDmList: // DM 조회하기
                return .run { [id = UserDefaultsManager.shared.recentGroupId] send in
                    do {
                        let result = try await NetworkService.shared.getDmList(workspaceId: id)
                        await send(.getUnreadDmCounts(result))
                    } catch {
                        print("2", error)
                    }
                }
                
            case .getUnreadDmCounts(let dms): // 안 읽은 메시지수 조회
                return .run { [id = UserDefaultsManager.shared.recentGroupId] send in
                    var directMessages: [DirectMessage] = []
                    
                    for dm in dms {
                        do {
                            let result = try await NetworkService.shared.getUnreadDms(workspaceId: id, roomlId: dm.roomId, after: dm.createdAt)
                            var directMessage = DirectMessage(roomId: dm.roomId, createdAt: dm.createdAt, user: dm.user)
                            directMessage.unreadCount = result.count
                            directMessages.append(directMessage)
                        } catch {
                            print("3", error)
                        }
                    }
                    
                    await send(.getDmChattings(directMessages))
                }
                
            case .getDmChattings(let dms):
                return .run { [groupId = UserDefaultsManager.shared.recentGroupId] send in
                    var lastDms: [DmChattingDTO] = []
                    
                    for dm in dms {
                        do {
                            let result = try await NetworkService.shared.getDmChattings(workspaceId: groupId, roomId: dm.roomId, after: "")
                            guard let lastDm = result.last else { continue }
                            lastDms.append(lastDm)
                        } catch {
                            print("4", error)
                        }
                    }
                    
                    await send(.setDmChattings(lastDms))
                }
                
            case .setDmChattings(let dms):
                state.dmList = dms.map { $0.toDmChatting() }
                return .none
                
            case .createDmChatRoom(let opponentId):
                return .run { [groupId = UserDefaultsManager.shared.recentGroupId]send in
                    do {
                        let result = try await NetworkService.shared.createDmChatRoom(workspaceId: groupId, opponentId: opponentId)
                        print(result)
                    } catch {
                        print(error)
                    }
                }
            default:
                return .none
            }
        }
    }
}
