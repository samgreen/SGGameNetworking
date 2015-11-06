//
//  GameServer.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import UIKit

enum SGDataTag: Int {
    case HeaderTag
    case BodyTag
}

protocol SGGameServerDelegate {
    func playerDidConnect(player: SGGamePlayer)
    func playerDidDisconnect(player: SGGamePlayer)
    
    func didReceivePacketFromPlayer(player: SGGamePlayer, packet: SGGamePacket)
}

class SGGameServer: NSObject, GCDAsyncSocketDelegate {
    var delegate: SGGameServerDelegate?
    var service: SGGameServerNetService!
    
    private var socket: GCDAsyncSocket!
    private let queue: dispatch_queue_t
    
    private var players = [GCDAsyncSocket: SGGamePlayer]()
    private let name: String
    
    override init() {
        fatalError("Call init(name:) instead.")
    }
    
    init(name: String) {
        self.name = name
        queue = dispatch_queue_create("com.sggamenetworking.\(name)", DISPATCH_QUEUE_SERIAL)
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }
    
    func startListening() throws {
        do {
            try socket.acceptOnPort(0)
        } catch {
            print("Unable to bind socket.")
        }
        
        service = SGGameServerNetService(name: name, port: Int32(socket.localPort))
        service.startPublishing()
    }
    
    func stopListening() {
        socket.disconnect()
        service.stopPublishing()
    }
    
    // MARK: GCDAsyncSocketDelegate
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Socket connected to address: \(newSocket.connectedHost)")
        
        let newAddress = newSocket.connectedAddress
        let player = SGGamePlayer(address: newAddress)
        players[newSocket] = player
        delegate?.playerDidConnect(player)
        
        newSocket.delegate = self
        newSocket.readHeaderData()
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        // Ensure we have a delegate and a valid data tag
        guard let dataTag = SGDataTag(rawValue: tag) else { return }
        
        if dataTag == .HeaderTag {
            
            // Parse the size of this packet
            let bodySize = parseSizeFromHeader(data)
            sock.readBodyDataWithLength(bodySize)
        } else if dataTag == .BodyTag {
            
            // If the packet is valid and we have a player
            if let packet = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? SGGamePacket {
                if let player = playerForSocket(sock) {
                    delegate?.didReceivePacketFromPlayer(player, packet: packet)
                }
            }
            // Queue next read for packet header size
            sock.readHeaderData()
        }
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        if let player = playerForSocket(sock) {
            delegate?.playerDidDisconnect(player)
        }
        
        sock.delegate = nil
        players[sock] = nil
    }
    
    // MARK: Helpers
    private func parseSizeFromHeader(data: NSData) -> Int {
        let pointer = UnsafePointer<Int>(data.bytes)
        let iPointer =  UnsafePointer<Int>(pointer)
        return iPointer.memory
    }
    
    private func playerForSocket(socket: GCDAsyncSocket) -> SGGamePlayer? {
        return players[socket] ?? nil
    }
}