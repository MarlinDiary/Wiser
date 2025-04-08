//
//  Icon.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import Foundation

struct Icon {
    let id: UUID
    let type: String
    let image: String
    
    init(type: String, image: String) {
        self.id = UUID()
        self.type = type
        self.image = image
    }
}

struct IconLibrary {
    let icons: [Icon]
    
    static let example: [Icon] = [
        Icon(type: "star", image: "star"),
        Icon(type: "heart", image: "heart"),
        Icon(type: "moon", image: "moon"),
    ]
}
