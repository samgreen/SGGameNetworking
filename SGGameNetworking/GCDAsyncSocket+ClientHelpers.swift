//
//  GCDAsyncSocket+ClientHelpers.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

extension GCDAsyncSocket {
    func writePlayerName(name: String) {
        writePacket(SGGamePacket(type: .PlayerName, object: "A Player Name"))
    }
    
    func writePacket(packet: SGGamePacket) {
        guard isConnected else { return }
        
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(packet)
        var size = archivedData.length
        let length = sizeof(Int)
        let archivedHeaderData = NSData(bytes: &size, length: length)
        let packetData = NSMutableData(data: archivedHeaderData)
        packetData.appendData(archivedData)
        
        writeData(packetData, withTimeout: -1, tag: 0)
    }
}