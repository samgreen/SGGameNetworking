//
//  GCDAsyncSocket+Helpers.swift
//  EverybodyPaintStuff
//
//  Created by Sam Green on 11/2/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

extension GCDAsyncSocket {
    func readHeaderData() {
        self.readDataToLength(UInt(sizeof(Int)), withTimeout: -1.0, tag: SGDataTag.HeaderTag.rawValue)
    }
    
    func readBodyDataWithLength(length: Int) {
        self.readDataToLength(UInt(length), withTimeout: -1, tag: SGDataTag.BodyTag.rawValue)
    }
}