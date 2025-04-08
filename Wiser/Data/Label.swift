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
    var icon: String
    
    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
    
    static let labelExamples = [
        Label(name: "Home", icon: "house"),
        Label(name: "Work", icon: "briefcase"),
        Label(name: "Family", icon: "heart"),
    ]
}
