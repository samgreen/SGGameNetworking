//
//  GameClient.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit
import CocoaAsyncSocket
import CoreMotion

struct SGGameServerHost {
    let name: String
    let address: NSData
}

protocol SGGameClientDelegate {
    func didFindServerHost(host: SGGameServerHost)
    
    func didConnect()
    func didDisconnect()
    
    func didReceivePacketFromPlayer(packet: SGGamePacket, player: SGGamePlayer)
}

class SGGameClient: NSObject {
    var delegate: SGGameClientDelegate?
    
    private let service: SGGameClientNetServiceBrowser
    private var socket: GCDAsyncSocket!
    private let queue: dispatch_queue_t
    
    override init() {
        fatalError("Call init(name:) instead.")
    }
    
    init(name: String) {
        queue = dispatch_queue_create("com.sggamenetworking.\(name)", DISPATCH_QUEUE_SERIAL)
        service = SGGameClientNetServiceBrowser(name: name)
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        service.delegate = self
    }
    
    func startSearchingForGames() {
        service.startBrowsing()
    }
    
    func stopSearchingForGames() {
        service.stopBrowsing()
    }
    
    func connectToHost(host: SGGameServerHost) {
        do {
            try socket.connectToAddress(host.address)
        } catch {
            print("Failed to connect to remote service.")
        }
    }
}

// MARK: GameClientNetServiceBrowserDelegate
extension SGGameClient: SGGameClientNetServiceBrowserDelegate {
    func didFindService(service: NSNetService) {
        if let address = service.addresses?.first {
            delegate?.didFindServerHost(SGGameServerHost(name: service.name, address: address))
        }
    }
}

// MARK: GCDAsyncSocketDelegate
extension SGGameClient: GCDAsyncSocketDelegate {
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Connected to address: \(sock.connectedHost):\(sock.connectedPort)")
        delegate?.didConnect()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError error: NSError!) {
        print("Failed to connect to address. Details: \(error)")
        delegate?.didDisconnect()
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
//        print("Did send data! Tag \(tag)")
    }
    
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Accepted new socket on client.")
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        print("Received data from address: \(socket.connectedHost)")
    }
}