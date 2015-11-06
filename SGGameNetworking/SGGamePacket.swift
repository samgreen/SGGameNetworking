//
//  PaintPacker.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol SGGamePacketCoding {
    init(fromData: NSData?)
    func toData() -> NSData?
}

@objc(SGGamePacket)
class SGGamePacket: NSObject, NSCoding {
    let object: AnyObject?
    
    override init() {
        fatalError("You must use init(type, data)")
    }
    
    init(object: AnyObject?) {
        self.object = object
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.object = aDecoder.decodeObjectForKey("object")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let object = self.object {
            aCoder.encodeObject(object, forKey: "object")
        }
    }
}