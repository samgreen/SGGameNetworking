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

protocol SGGameClientDelegate {
    func didConnect()
    func didDisconnect()
}

class SGGameClient: NSObject {
    var delegate: SGGameClientDelegate?
    
    var socket: GCDAsyncSocket!
    let queue = dispatch_queue_create("com.sggamenetworking.client", DISPATCH_QUEUE_SERIAL)
    
    var service = SGGameClientNetServiceBrowser()
    
    override init() {
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: queue)
        service.delegate = self
    }
    
    func startSearchingForGames() {
        service.startBrowsing()
    }
}

// MARK: GameClientNetServiceBrowserDelegate
extension SGGameClient: SGGameClientNetServiceBrowserDelegate {
    func didFindService(service: NSNetService) {
        if let address = service.addresses?.first {
            do {
                try socket.connectToAddress(address)
            } catch {
                print("Failed to connect to remote service.")
            }
        }
    }
}

// MARK: GCDAsyncSocketDelegate
extension SGGameClient: GCDAsyncSocketDelegate {
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Connected to address: \(sock.connectedHost):\(sock.connectedPort)")
        service.stopBrowsing()
        delegate?.didConnect()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError error: NSError!) {
        print("Failed to connect to address. Details: \(error)")
        // Auto reconnect with browse
        service.startBrowsing()
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