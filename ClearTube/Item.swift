//
//  Item.swift
//  ClearTube
//
//  Created by Peter Jang on 9/13/24.
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
