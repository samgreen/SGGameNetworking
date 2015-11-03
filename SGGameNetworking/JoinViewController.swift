//
//  JoinViewController.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class JoinViewController: UIViewController, SGGameClientDelegate {
    let client = SGGameClient()
    
    func startSearchingForGames() {
        client.delegate = self
        client.startSearchingForGames()
    }
    
    func didConnect() {
        print("Connected")
    }
    
    func didDisconnect() {
        print("Disconnected")
    }
    
    func didReceivePacketFromPlayer(packet: SGGamePacket, player: SGGamePlayer) {
        print("Received packet from player")
    }
}