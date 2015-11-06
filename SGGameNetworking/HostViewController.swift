//
//  HostViewController.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class HostViewController: UITableViewController, SGGameServerDelegate {
    let server = SGGameServer(name: "ExampleGame")
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startHosting()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopHosting()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: SGGameServerDelegate
    func playerDidConnect(player: SGGamePlayer) {
        print("Player connected: \(player)")
    }
    
    func playerDidDisconnect(player: SGGamePlayer) {
        print("Player disconnected: \(player)")
    }
    
    func didReceivePacketFromPlayer(player: SGGamePlayer, packet: SGGamePacket) {
        print("Received packet from player: \(player)")
    }
    
    // MARK: Helpers
    func startHosting() {
        do {
            try server.startListening()
            print("Host server started successfully.")
        } catch {
            print("Server failed to start listening.")
        }
    }
    
    func stopHosting() {
        server.stopListening()
    }
}