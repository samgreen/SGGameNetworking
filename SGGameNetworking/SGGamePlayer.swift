//
//  Player.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 11/1/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

class SGGamePlayer: Hashable, Equatable {
    let address: NSData
    var hashValue: Int { return address.hashValue }
    
    init(address: NSData) {
       self.address = address
    }
}

func ==(player: SGGamePlayer, otherPlayer: SGGamePlayer) -> Bool {
    return player.hashValue == otherPlayer.hashValue
}