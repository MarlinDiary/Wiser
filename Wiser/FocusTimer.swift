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

    var totalMinutes: Int {
        Int(elapsedSeconds) / 60
    }

    var displaySeconds: Int {
        Int(elapsedSeconds) % 60
    }

    func start() {
        isRunning = true
        isPaused = false
        elapsedSeconds = 0
        accumulatedBeforePause = 0
        sessionStartDate = Date()
        startDate = sessionStartDate
        startTimer()
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
    }

    func resume() {
        guard isRunning, isPaused else { return }
        isPaused = false
        startDate = Date()
        startTimer()
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
}
