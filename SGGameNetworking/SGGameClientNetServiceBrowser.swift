//
//  GameClientNetServiceBrowser.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol SGGameClientNetServiceBrowserDelegate {
    func didFindService(service: NSNetService)
}

class SGGameClientNetServiceBrowser: NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    var delegate: SGGameClientNetServiceBrowserDelegate?
    
    let serviceBrowser = NSNetServiceBrowser()
    var services = [NSNetService]()
    let name: String
    
    override init() {
        fatalError("You must call init(name:)")
    }
    
    init(name: String) {
        self.name = name
        
        super.init()
        
        startBrowsing()
    }
    
    func startBrowsing() {
        serviceBrowser.delegate = self
        serviceBrowser.searchForServicesOfType(".\(self.name)._tcp.", inDomain: "local")
    }
    
    func stopBrowsing() {
        serviceBrowser.delegate = nil
        serviceBrowser.stop()
        services.removeAll()
    }
    
    // MARK: NSNetServiceBrowserDelegate
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        print("Found service: \(service)")
        
        service.delegate = self
        service.resolveWithTimeout(30)
        
        services.append(service)
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        print("Removed service: \(service)")
        
        if let index = services.indexOf(service) {
            service.delegate = nil
            services.removeAtIndex(index)
        }
    }
    
    // MARK: NSNetServiceDelegate
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Failed to resolve service: \(sender) - Details: \(errorDict)")
        
        sender.delegate = nil
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        print("Resolved address for service: \(sender)")
        
        if let delegate = self.delegate {
            delegate.didFindService(sender)
        }
    }
}