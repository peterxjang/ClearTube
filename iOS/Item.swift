//
//  Item.swift
//  iOSClearTube
//
//  Created by Peter Jang on 9/21/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
