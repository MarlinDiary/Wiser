//
//  SampleData.swift
//  Wiser
//
//  Created by Marlin on 29/03/2026.
//

import Foundation
import SwiftData

#if DEBUG
enum SampleData {
    static func insert(into context: ModelContext) {
        let calendar = Calendar.current
        let now = Date()

        // Check if sample data already exists
        let descriptor = FetchDescriptor<FocusSession>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let entries: [(daysAgo: Int, hour: Int, durationMinutes: Int)] = [
            // Today
            (0, 9, 45),
            (0, 14, 30),
            // Yesterday
            (1, 8, 60),
            (1, 10, 25),
            (1, 15, 50),
            // 2 days ago
            (2, 7, 90),
            (2, 13, 20),
            // 3 days ago
            (3, 9, 35),
            (3, 16, 40),
            // 4 days ago
            (4, 10, 55),
            // 5 days ago
            (5, 8, 120),
            (5, 14, 45),
            // 1 week ago
            (7, 9, 60),
            (7, 11, 30),
            // 2 weeks ago
            (14, 10, 75),
            (14, 15, 40),
            // 3 weeks ago
            (21, 8, 50),
            // 1 month ago
            (30, 9, 90),
            (30, 14, 60),
            // 2 months ago
            (60, 10, 45),
            (60, 16, 30),
            // 3 months ago
            (90, 9, 120),
        ]

        for entry in entries {
            let startOfDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -entry.daysAgo, to: now)!)
            let startDate = calendar.date(byAdding: .hour, value: entry.hour, to: startOfDay)!
            let session = FocusSession(
                startDate: startDate,
                durationSeconds: TimeInterval(entry.durationMinutes * 60)
            )
            context.insert(session)
        }
    }
}
#endif
