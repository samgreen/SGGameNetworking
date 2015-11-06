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
    var playerToView = [SGGamePlayer: UIView]()
    
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.addSubview(view)
        playerToView[player] = view
    }
    
    func playerDidDisconnect(player: SGGamePlayer) {
        if let view = playerToView[player] {
            view.removeFromSuperview()
        }
    }
    
    func didReceivePacketFromPlayer(player: SGGamePlayer, packet: SGGamePacket) {
        print("Received packet from player")
    }
}

extension GameViewController: SGGameClientDelegate {
    func didFindServerHost(host: SGGameServerHost) {
        print("Found host: \(host.name)")
    }
    
    func didConnect() {
        
    }
    
    func didDisconnect() {
        
    }
    
    func didReceivePacketFromPlayer(packet: SGGamePacket, player: SGGamePlayer) {
        print("Received packet from player")
    }
}