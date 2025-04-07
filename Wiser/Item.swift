//
//  Item.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
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
