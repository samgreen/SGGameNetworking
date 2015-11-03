//
//  GameViewController.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    var server: SGGameServer? {
        didSet {
            self.server?.delegate = self
        }
    }
    var client: SGGameClient? {
        didSet {
            self.client?.delegate = self
        }
    }
}

extension GameViewController: SGGameServerDelegate {
    func playerDidConnect(player: SGGamePlayer) {
        
    }
    
    func playerDidDisconnect(player: SGGamePlayer) {
        
    }
    
    func didReceivePacketFromPlayer(player: SGGamePlayer, packet: SGGamePacket) {
        print("Received packet from player")
    }
}

extension GameViewController: SGGameClientDelegate {
    func didConnect() {
        
    }
    
    func didDisconnect() {
        
    }
    
    func didReceivePacketFromPlayer(packet: SGGamePacket, player: SGGamePlayer) {
        print("Received packet from player")
    }
}