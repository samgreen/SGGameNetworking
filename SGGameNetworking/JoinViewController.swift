//
//  JoinViewController.swift
//  SGGameNetworking
//
//  Created by Sam Green on 11/3/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class JoinViewController: UITableViewController, SGGameClientDelegate {
    let client = SGGameClient(name: "ExampleGame")
    var hosts = [SGGameServerHost]()
    
    // MARK: UIViewController
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startSearchingForGames()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopSearchingForGames()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: UITableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JoinCell", forIndexPath: indexPath)
        cell.textLabel?.text = hosts[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        client.connectToHost(hosts[indexPath.row])
    }
    
    // MARK: Helpers
    func startSearchingForGames() {
        client.delegate = self
        client.startSearchingForGames()
    }
    
    func stopSearchingForGames() {
        client.stopSearchingForGames()
    }
    
    // MARK: SGGameClientDelegate
    func didFindServerHost(host: SGGameServerHost) {
        print("Found host: \(host.name)")
        
        hosts.append(host)
        tableView.reloadData()
    }
    
    func didConnect() {
        print("Connected")
        stopSearchingForGames()
    }
    
    func didDisconnect() {
        print("Disconnected")
    }
    
    func didReceivePacketFromPlayer(packet: SGGamePacket, player: SGGamePlayer) {
        print("Received packet from player")
    }
}