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
        case viewOnAppear // viewOnAppear
        case getAllMembers // 그룹 내 모든 멤버 리스트 가져오기
        case setAllMembers([MemberDTO]) // 가져온 멤버 리스트 반영하기
        case getDmList // 디엠 리스트 가져오기
        case getUnreadDmCounts([DmDTO]) // 디엠 안 읽은 개수 가져오기
        case getDmChattings([DirectMessage]) // 디엠 채팅 가져오기 
        case setDmChattings([DmChatting]) // 디엠 채팅 반영하기 (= 마지막 채팅 보여주기)
        case createDmChatRoom(String) // 채팅방 생성
        case setDmChatRoomInfo(DirectMessage) // 하위 Reducer에 채팅방 정보 넘겨주기 
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
                        print(error)
                    }
                }
                
            case .setAllMembers(let list): // 모든 멤버 읽어오기
                state.memberList = list.filter { $0.userId != UserDefaultsManager.shared.userId }.map { $0.toStudyGroupMember() }
                return .none
                
            case .getDmList: // DM 조회하기
                return .run { [id = UserDefaultsManager.shared.recentGroupId] send in
                    do {
                        let result = try await NetworkService.shared.getDmList(workspaceId: id)
                        await send(.getUnreadDmCounts(result))
                    } catch {
                        print(error)
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
                            print(error)
                        }
                    }
                    
                    await send(.getDmChattings(directMessages))
                }
                
            case .getDmChattings(let dms): // 디엠 마지막 채팅 가져오기
                return .run { [groupId = UserDefaultsManager.shared.recentGroupId] send in
                    var lastDms: [DmChatting] = []
                    
                    for dm in dms {
                        do {
                            let result = try await NetworkService.shared.getDmChattings(workspaceId: groupId, roomId: dm.roomId, after: "")
                            guard let last = result.last else { continue }
                            var lastDm = last.toDmChatting()
                            lastDm.unreadCount = dm.unreadCount
                            lastDms.append(lastDm)
                        } catch {
                            print(error)
                        }
                    }
                    
                    await send(.setDmChattings(lastDms))
                }
                
            case .setDmChattings(let dms): // 채팅 반영
                state.dmList = dms
                return .none
                
            case .createDmChatRoom(let opponentId): // 디엠 채팅방 생성
                return .run { [groupId = UserDefaultsManager.shared.recentGroupId]send in
                    do {
                        let result = try await NetworkService.shared.createDmChatRoom(workspaceId: groupId, opponentId: opponentId)
                        await send(.setDmChatRoomInfo(result.toDirectMessage()))
                    } catch {
                        print(error)
                    }
                }
                
            case .setDmChatRoomInfo(let info): // 디엠 채팅방 정보 세팅
                state.directMessageReducerState.chatRoomInfo = info
                return .none
                
            default:
                return .none
            }
        }
    }
}
