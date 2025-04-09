//
//  Icon.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import Foundation
import SwiftData

@Model
class Icon {
    var id: UUID
    var type: String
    var image: String
    
    init(type: String, image: String) {
        self.id = UUID()
        self.type = type
        self.image = image
    }
}

extension Icon {
    static let dog = Icon(type: "example", image: "dog")
    static let grass = Icon(type: "example", image: "grass")
    static let boxing = Icon(type: "example", image: "boxing")
}
