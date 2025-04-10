//
//  Label.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import Foundation
import SwiftData

@Model
class Label {
    var id: UUID
    var name: String
    var icon: Icon
    var isActive: Bool
    
    init(name: String, icon: Icon, isActive: Bool = true) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.isActive = isActive
    }
    
    static let exampleLabels: [Label] = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing, isActive: false)
    ]
}
