//
//  TimeLog.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import Foundation
import SwiftData

@Model
class TimeLog {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var label: Label?
    
    init(startTime: Date, endTime: Date? = nil, label: Label? = nil) {
        self.id = UUID()
        self.startTime = startTime
        self.endTime = endTime
        self.label = label
    }
    
    static let exampleTimeLogs: [TimeLog] = [
        TimeLog(
            startTime: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            endTime: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
            label: Label.exampleLabels[0]
        ),
        TimeLog(
            startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            endTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!.addingTimeInterval(3600),
            label: Label.exampleLabels[1]
        )
    ]
} 
