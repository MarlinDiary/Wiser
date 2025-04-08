//
//  Label.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import Foundation

class Label: Codable {
    let id: UUID
    var name: String
    var icon: Icon
    
    init(name: String, icon: Icon) {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
    
    static let exampleLabels: [Label] = [
        Label(name: "dog", icon: Icon(type: "example", image: "dog")),
        Label(name: "grass", icon: Icon(type: "example", image: "grass")),
        Label(name: "boxing", icon: Icon(type: "example", image: "boxing"))
    ]
}
