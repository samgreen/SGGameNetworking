//
//  HostViewController.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class HostViewController: UIViewController, SGGameServerDelegate {
    let server = SGGameServer()
    
    func startHosting() {
        do {
            try server.startListening()
        } catch {
            print("Server failed to start listening.")
        }
    }
    
    func playerDidConnect(player: SGGamePlayer) {
        print("Player connected: \(player)")
    }
    
    func playerDidDisconnect(player: SGGamePlayer) {
        print("Player disconnected: \(player)")
    }
    
    func didReceivePacketFromPlayer(player: SGGamePlayer, packet: SGGamePacket) {
        print("Received packet from player: \(player)")
    }
}