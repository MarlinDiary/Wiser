//
//  FocusSession.swift
//  Wiser
//
//  Created by Marlin on 27/03/2026.
//

import Foundation
import SwiftData

@Model
final class FocusSession {
    var startDate: Date
    var durationSeconds: TimeInterval

    var durationMinutes: Int {
        Int(durationSeconds) / 60
    }

    init(startDate: Date, durationSeconds: TimeInterval) {
        self.startDate = startDate
        self.durationSeconds = durationSeconds
    }

    static func splitByDay(startDate: Date, durationSeconds: TimeInterval) -> [FocusSession] {
        let calendar = Calendar.current
        let endDate = startDate.addingTimeInterval(durationSeconds)
        var sessions: [FocusSession] = []
        var current = startDate

        while current < endDate {
            let nextMidnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: current)!)
            let segmentEnd = min(nextMidnight, endDate)
            let segmentDuration = segmentEnd.timeIntervalSince(current)
            sessions.append(FocusSession(startDate: current, durationSeconds: segmentDuration))
            current = segmentEnd
        }

        return sessions
    }
}
