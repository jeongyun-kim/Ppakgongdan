//
//  SocketService.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/26/24.
//

import Foundation
import Combine
import SocketIO

public final class SocketService: NSObject {
    public static let shared = SocketService()
    var manager: SocketManager!
    var socket: SocketIOClient!
    public let chatPublisher = CurrentValueSubject<ChannelChatting?, Never>(nil)
    private let baseURL = APIKey.baseURL
    private let eventName = "channel"
    
    private override init() {
        super.init()
        print("INIT!!!!!!!!!!!!!!")
        self.manager = SocketManager(socketURL: baseURL, config: [.log(true), .compress])
        self.socket = self.manager.defaultSocket
    }
    
    // 각 이벤트마다의 액션 정의 및 등록
    private func addEventHandlers() {
        socket.once(clientEvent: .connect) { data, ack in
            print("👏 Socket is connected", data, ack)
        }
        
        socket.once(clientEvent: .error) { data, ack in
            print("⚠️ Socket connection failed", data, ack)
        }
        
        socket.on(eventName) { dataArr, ack in
            print("🟢 Channel Recieved")
            if let data = dataArr.first as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let result = try JSONDecoder().decode(ChannelChattingDTO.self, from: jsonData)
                    self.chatPublisher.send(result.toChannelChatting())
                } catch {
                    print("Error parsing channel data: \(error)")
                }
            }
        }
        
        socket.once(clientEvent: .disconnect) { data, ack in
            print("❌ Socket is disconnected")
        }
    }
    
    // 소켓 통신 연결 등록 
    public func estabilishConnection(channelId: String) {
        socket = self.manager.socket(forNamespace: "\(APIKey.socketChanelPath)\(channelId)")
        addEventHandlers()
        socket.connect()
    }
    
    // 소켓 통신 연결 해제
    public func disconnectSocket() {
        socket.disconnect()
    }
}
