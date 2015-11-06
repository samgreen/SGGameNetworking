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
    
    private let serviceBrowser = NSNetServiceBrowser()
    private var services = [NSNetService]()
    private let name: String
    
    override init() {
        fatalError("Call init(name:) instead.")
    }
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
    func startBrowsing() {
        serviceBrowser.delegate = self
        serviceBrowser.searchForServicesOfType("_\(self.name)._tcp.", inDomain: "local")
    }
    
    func stopBrowsing() {
        serviceBrowser.delegate = nil
        serviceBrowser.stop()
        services.removeAll()
    }
    
    // MARK: NSNetServiceBrowserDelegate
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        print("Found service: \(service)")
        
        services.append(service)
        
        service.delegate = self
        service.resolveWithTimeout(30)
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
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        print("Resolved address for service: \(sender)")
        
        if let delegate = self.delegate {
            delegate.didFindService(sender)
        }
    }
}