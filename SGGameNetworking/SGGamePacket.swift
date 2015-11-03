//
//  PaintPacker.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 10/31/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

// Ugly work around to fix Swift namespacing across the two targets
@objc
enum SGPacketType: Int32 {
    case PlayerName
}

@objc(SGGamePacket)
class SGGamePacket: NSObject, NSCoding {
    let type: SGPacketType
    var typeString: String {
        switch self.type {
        case .PlayerName: return "PlayerName"
        }
    }
    let object: AnyObject?
    
    override init() {
        fatalError("You must use init(type, data)")
    }
    
    init(type: SGPacketType, object: AnyObject?) {
        self.type = type
        self.object = object
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = SGPacketType(rawValue: aDecoder.decodeInt32ForKey("type"))!
        self.object = aDecoder.decodeObjectForKey("object")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(type.rawValue, forKey: "type")
        if let object = self.object {
            aCoder.encodeObject(object, forKey: "object")
        }
    }
}