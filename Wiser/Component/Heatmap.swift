//
//  Heatmap.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct Heatmap: View {
    @State private var heatmapData: [[HeatmapDotStatus]] = Array(
            repeating: Array(repeating: .blank, count: 12),
            count: 24
        )
    @State private var timer: Timer?
    
    var body: some View {
            HStack(spacing: 6) {
                ForEach(0..<24, id: \.self) { column in
                    VStack(spacing: 6) {
                        Text(String(format: "%02d", column))
                            .font(.system(size: 7))
                            .foregroundStyle(.secondary)
                        
                        ForEach(0..<12, id: \.self) { row in
                            HeatmapDot(status: heatmapData[column][row])
                        }
                    }
                }
            }
            .onAppear {
                updateCurrentTimeDot()
                scheduleNextUpdate()
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
    }
    
    private func scheduleNextUpdate() {
        // Cancel existing timer
        timer?.invalidate()
        
        // Calculate next 5-minute boundary
        let now = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: now)
        let second = calendar.component(.second, from: now)
        
        // Calculate current position within the 5-minute interval
        let minuteInInterval = minute % 5
        let secondsToNextInterval = TimeInterval((4 - minuteInInterval) * 60 + (60 - second))
        
        // If already at boundary, calculate time to next 5-minute boundary
        let timeToNextUpdate = secondsToNextInterval > 0 ? secondsToNextInterval : 300
        
        // Create one-time timer that triggers at the next 5-minute boundary
        timer = Timer.scheduledTimer(withTimeInterval: timeToNextUpdate, repeats: false) { [self] _ in
            updateCurrentTimeDot()
            // Recursive call to set up the next update
            scheduleNextUpdate()
        }
    }
    
    private func updateCurrentTimeDot() {
        // Reset all dots with .now status
        for column in 0..<heatmapData.count {
            for row in 0..<heatmapData[column].count {
                if heatmapData[column][row] == .now {
                    heatmapData[column][row] = .blank
                }
            }
        }
        
        // Get current hour and minute
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        // Calculate corresponding row (minute/5)
        let row = minute / 5
        
        // Update current time dot status to .now
        if hour < heatmapData.count && row < heatmapData[0].count {
            heatmapData[hour][row] = .now
        }
    }
}

#Preview {
    Heatmap()
}
