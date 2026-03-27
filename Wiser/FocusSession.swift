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
}
