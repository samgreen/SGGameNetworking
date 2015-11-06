//
//  GameServerNetService.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

class SGGameServerNetService: NSObject, NSNetServiceDelegate {
    private var service: NSNetService!
    private let name: String
    
    override init() {
        fatalError("Call init(name:, port:) instead.")
    }
    
    init(name: String, port: Int32) {
        self.name = name
        
        super.init()
        
        service = NSNetService(domain: "local", type: "_\(self.name)._tcp.", name: self.name, port: port)
    }
    
    func startPublishing() {
        service.delegate = self
        service.publish()
    }
    
    func stopPublishing() {
        service.delegate = nil
        service.stop()
    }
    
    // MARK: NSNetServiceDelegate
    func netServiceDidPublish(sender: NSNetService) {
        print("Published net service: Type \(sender.type) - Name \(sender.name) - Port \(sender.port)")
    }
    
    func netService(sender: NSNetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish net service: Type \(sender.type) - Name \(sender.name) - Error: \(errorDict)")
    }
}
