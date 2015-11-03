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

class GameServer: NSObject, GCDAsyncSocketDelegate {
    var delegate: SGGameServerDelegate?
    
    var socket: GCDAsyncSocket!
    let queue = dispatch_queue_create("com.everybodypaintstuff.server", DISPATCH_QUEUE_SERIAL)
    
    var service: GameServerNetService!
    
    var players = [GCDAsyncSocket: SGGamePlayer]()
    
    override init() {
        super.init()
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }
    
    func startListening() throws {
        do {
            try socket.acceptOnPort(0)
        } catch {
            print("Unable to bind socket.")
        }
        
        service = GameServerNetService(name: String(self), port: Int32(socket.localPort))
    }
    
    // MARK: GCDAsyncSocketDelegate
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        guard let delegate = self.delegate else { return }
        guard let dataTag = SGDataTag(rawValue: tag) else { return }
        
        if dataTag == .HeaderTag {
            let bodySize = parseSizeFromHeader(data)
            sock.readBodyDataWithLength(bodySize)
        } else if dataTag == .BodyTag {
            if let packet = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? SGGamePacket {
                if let player = playerForSocket(sock) {
                    delegate.didReceivePacketFromPlayer(player, packet: packet)
                }
            }
            
            // Queue next read for packet header size
            sock.readHeaderData()
        }
    }
    
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Socket connected to address: \(newSocket.connectedHost)")
        
        guard let delegate = self.delegate else { return }
        
        let newAddress = newSocket.connectedAddress
        let player = SGGamePlayer(address: newAddress)
        players[newSocket] = player
        delegate.playerDidConnect(player)
        
        newSocket.delegate = self
        newSocket.readHeaderData()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("Socket disconnected: \(sock.connectedHost)")
        
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