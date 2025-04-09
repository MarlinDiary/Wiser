//
//  TempTimeRecord.swift
//  Wiser
//
//  Created by Claude on 2025/4/10.
//

import Foundation
import SwiftData

struct TempTimeRecord: Identifiable, Equatable {
    let id = UUID()
    let startTime: Date
    var endTime: Date?
    let label: Label
} 
