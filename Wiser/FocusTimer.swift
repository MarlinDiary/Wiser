//
//  FocusTimer.swift
//  Wiser
//
//  Created by Marlin on 27/03/2026.
//

import Foundation

@Observable
final class FocusTimer {
    private(set) var isRunning = false
    private(set) var isPaused = false
    private(set) var elapsedSeconds: TimeInterval = 0

    private(set) var sessionStartDate: Date?
    private var startDate: Date?
    private var accumulatedBeforePause: TimeInterval = 0
    private var timer: Timer?

    private let defaults = UserDefaults.standard
    private enum Keys {
        static let isRunning = "FocusTimer.isRunning"
        static let isPaused = "FocusTimer.isPaused"
        static let sessionStartDate = "FocusTimer.sessionStartDate"
        static let startDate = "FocusTimer.startDate"
        static let accumulated = "FocusTimer.accumulated"
    }

    var totalMinutes: Int {
        Int(elapsedSeconds) / 60
    }

    var displaySeconds: Int {
        Int(elapsedSeconds) % 60
    }

    init() {
        restore()
    }

    func start() {
        isRunning = true
        isPaused = false
        elapsedSeconds = 0
        accumulatedBeforePause = 0
        sessionStartDate = Date()
        startDate = sessionStartDate
        startTimer()
        save()
    }

    func stop() -> (startDate: Date, duration: TimeInterval)? {
        guard let sessionStart = sessionStartDate else { return nil }
        let finalDuration = elapsedSeconds
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        startDate = nil
        sessionStartDate = nil
        accumulatedBeforePause = 0
        elapsedSeconds = 0
        clearSaved()
        return (sessionStart, finalDuration)
    }

    func pause() {
        guard isRunning, !isPaused else { return }
        isPaused = true
        timer?.invalidate()
        timer = nil
        if let startDate {
            accumulatedBeforePause += Date().timeIntervalSince(startDate)
        }
        startDate = nil
        save()
    }

    func resume() {
        guard isRunning, isPaused else { return }
        isPaused = false
        startDate = Date()
        startTimer()
        save()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.tick()
        }
    }

    private func tick() {
        guard let startDate else { return }
        elapsedSeconds = accumulatedBeforePause + Date().timeIntervalSince(startDate)
    }

    private func save() {
        defaults.set(isRunning, forKey: Keys.isRunning)
        defaults.set(isPaused, forKey: Keys.isPaused)
        defaults.set(sessionStartDate, forKey: Keys.sessionStartDate)
        defaults.set(startDate, forKey: Keys.startDate)
        defaults.set(accumulatedBeforePause, forKey: Keys.accumulated)
    }

    private func clearSaved() {
        defaults.removeObject(forKey: Keys.isRunning)
        defaults.removeObject(forKey: Keys.isPaused)
        defaults.removeObject(forKey: Keys.sessionStartDate)
        defaults.removeObject(forKey: Keys.startDate)
        defaults.removeObject(forKey: Keys.accumulated)
    }

    private func restore() {
        guard defaults.bool(forKey: Keys.isRunning) else { return }

        isRunning = true
        isPaused = defaults.bool(forKey: Keys.isPaused)
        sessionStartDate = defaults.object(forKey: Keys.sessionStartDate) as? Date
        startDate = defaults.object(forKey: Keys.startDate) as? Date
        accumulatedBeforePause = defaults.double(forKey: Keys.accumulated)

        if isPaused {
            elapsedSeconds = accumulatedBeforePause
        } else if let startDate {
            elapsedSeconds = accumulatedBeforePause + Date().timeIntervalSince(startDate)
            startTimer()
        }
    }
}
