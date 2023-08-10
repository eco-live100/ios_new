//
//  SocketIOManager.swift
//  EcoLive
//
//  Created by 21Twelve Interactive on 27/09/21.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {

    static let shared = SocketIOManager()
    
    // MARK: - Properties
    let manager = SocketManager(socketURL: URL(string: "https://www.ecolive.global:3001/")!, config: [.log(false), .compress])
    var socket: SocketIOClient? = nil

    // MARK: - Life Cycle
    override init() {
        super.init()
        
        setupSocket()
        setupSocketEvents()
        socket?.connect()
    }

    func stop() {
        socket?.removeAllHandlers()
    }

    // MARK: - Socket Setup
    func setupSocket() {
        self.socket = manager.defaultSocket
    }

    func makeConnectionFromAppDelegate() {
        socket?.on(clientEvent: SocketClientEvent.connect) { (dataArray, socketAck) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "socketConnectedFromAppDelegate"), object: nil, userInfo: nil)
        }
    }
    
    func setupSocketEvents() {
//        if socket?.status != SocketIOStatus.notConnected {
            socket?.on(clientEvent: .connect) {data, ack in
                debugPrint("Connected")
            }
//        }
        
        socket?.on("_online_") { (dataArray, socketAck) in
            debugPrint("Socket Manager -  online user")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: OnlineUser), object: nil)
        }
        
        socket?.on("message") { (dataArray, socketAck) in
            debugPrint("Socket Manager - New Message Came")
            var dictdata = Dictionary<String,Any>()
            dictdata["data"] = dataArray[0] as! Dictionary<String,Any>
            NotificationCenter.default.post(name: Notification.Name(NewMessageKey), object: dictdata)
        }
        
        socket?.on("user_online") { (dataArray, socketAck) in
            debugPrint("Socket Manager - user joined")
            var dictdata = Dictionary<String,Any>()
            dictdata["data"] = dataArray[0] as! Dictionary<String,Any>
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserJoinedKey), object: dictdata)
        }
        
        socket?.on("user_disconnected") { (dataArray, socketAck) in
            debugPrint("Socket Manager -  disconneted user")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserLeftKey), object: dataArray[0] as! [String: AnyObject])
        }
        
//        socket?.on("user left") { (dataArray, socketAck) in
//            debugPrint("Socket Manager -  User Left")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: OnlineUser), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserLeftKey), object: dataArray[0] as! [String: AnyObject])
//        }
        
//        socket?.on("message") { (dataArray, socketAck) in
//            debugPrint("Socket Manager -  Message")
//            var dictdata = Dictionary<String,AnyObject>()
//            dictdata["data"] = dataArray[0] as! Dictionary<String,AnyObject> as AnyObject
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: getMessagesKey), object: dictdata)
//        }
        
        /*
        socket?.on("login") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketLogin = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("Now this chat has \(response.numUsers) users.")
//            }
        }

        socket?.on("user joined") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketUserJoin = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("User '\(response.username)' joined...")
//                debugPrint("Now this chat has \(response.numUsers) users.")
//            }
        }

        socket?.on("user left") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketUserLeft = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("User '\(response.username)' left...")
//                debugPrint("Now this chat has \(response.numUsers) users.")
//            }
        }

        socket?.on("new message") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketMessage = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("Message from '\(response.username)': \(response.message)")
//            }
        }

        socket?.on("typing") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketUserTyping = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("User \(response.username) is typing...")
//            }
        }

        socket?.on("stop typing") { (data, ack) in
            guard let dataInfo = data.first else { return }
//            if let response: SocketUserTyping = try? SocketParser.convert(data: dataInfo) {
//                debugPrint("User \(response.username) stopped typing...")
//            }
        }
        */
    }

    // MARK: - Socket Emits
    func emitUserOnline(Data : [String : AnyObject]) {
        debugPrint("Emit online user")
        socket?.emit("_online_", Data)
    }
    
    func sendMessage(Data : [String : AnyObject]) {
        socket?.emit("message", Data)
    }
    
    func emitUserDisconnect(Data : [String : AnyObject]) {
        debugPrint("Emit disconnect user")
        socket?.emit("disconnect", Data)
    }
    
//    func emitRemoveUser(RoomID:String) {
//        socket?.emit("remove user", RoomID)
//    }
//
//    func exitChatWithusername(username: String) {
//        socket?.emit("remove user", username)
//    }
    
//    func emitGetMessage(Data : [String : AnyObject]) {
//        debugPrint("reqested for get MEssages")
//        socket?.emit("message", Data)
//    }
    
//    func emitNewMessage(Data : [String : AnyObject]) {
//        socket?.emit("message", Data)
//    }
    
//    func register(user: String) {
//        socket?.emit("add user", user)
//    }
    
//    func send(message: String) {
//        socket?.emit("new message", message)
//    }
    //****//
//    func emitJoin(RoomID:String) {
//        socket?.emit("join", RoomID)
//    }
    //****//
    
//    func onNewMessage() {
//        socket?.on("message") { (dataArray, socketAck) in
//             debugPrint("Socket Manager - New Message Came")
//            var dictdata = Dictionary<String,Any>()
//            dictdata["data"] = dataArray[0] as! Dictionary<String,Any>
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NewMessageKey), object: dictdata)
//        }
//    }
    
//    func onUserJoined() {
//        socket?.on("user joined") { (dataArray, socketAck) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserJoinedKey), object: nil)
//        }
//    }
    
    //Distroy connections
    func ChatRoomDistroyConnections() {
        //socket.disconnect()
        socket?.off(clientEvent: SocketClientEvent.connect)
        socket?.off(clientEvent: SocketClientEvent.disconnect)
        socket?.off(clientEvent: SocketClientEvent.error)
        socket?.off("message")
        socket?.off("user_online")
        socket?.off("user_disconnected")
//        socket?.off("get messages")
    }
    
    func ChatListDistroyConnections() {
        socket?.disconnect()
        socket?.off(clientEvent: SocketClientEvent.connect)
        socket?.off(clientEvent: SocketClientEvent.disconnect)
        socket?.off(clientEvent: SocketClientEvent.error)
        socket?.off("_online_")
        socket?.off("user_disconnected")
//        socket?.off("update chatrooms")
    }
    
    func ChatRoomDistroyConnectionsFromPushNotification() {
        socket?.disconnect()
        socket?.off(clientEvent: SocketClientEvent.connect)
        socket?.off(clientEvent: SocketClientEvent.disconnect)
        socket?.off(clientEvent: SocketClientEvent.error)
        socket?.off("message")
        socket?.off("user_online")
        socket?.off("user_disconnected")
//        socket?.off("get messages")
    }
}
