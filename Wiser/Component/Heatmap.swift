//
//  Heatmap.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI
import SwiftData

struct Heatmap: View {
    @State private var heatmapData: [[HeatmapDotStatus]] = Array(
            repeating: Array(repeating: .blank, count: 12),
            count: 24
        )
    @State private var timer: Timer?
    @Query private var timeLogs: [TimeLog]
    
    // 初始化方法，设置查询过滤器只查询当天的日志
    init() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<TimeLog> { timeLog in
            timeLog.startTime >= startOfDay && timeLog.startTime < endOfDay
        }
        
        _timeLogs = Query(filter: predicate, sort: \TimeLog.startTime)
    }
    
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
                updateHeatmapFromTimeLogs()
                updateCurrentTimeDot()
                scheduleNextUpdate()
            }
            .onChange(of: timeLogs) { _, _ in
                updateHeatmapFromTimeLogs()
                updateCurrentTimeDot()
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
    
    private func updateHeatmapFromTimeLogs() {
        // 首先将所有记录点重置为空白
        // 保留当前的now状态
        var newHeatmapData = Array(
            repeating: Array(repeating: HeatmapDotStatus.blank, count: 12),
            count: 24
        )
        
        // 更新基于timeLogs的记录状态
        let calendar = Calendar.current
        
        for timeLog in timeLogs {
            // 只处理有startTime和endTime的日志
            guard let endTime = timeLog.endTime else { continue }
            
            // 计算覆盖的5分钟间隔
            var currentTime = timeLog.startTime
            
            while currentTime <= endTime {
                let hour = calendar.component(.hour, from: currentTime)
                let minute = calendar.component(.minute, from: currentTime)
                let row = minute / 5
                
                if hour < 24 && row < 12 {
                    newHeatmapData[hour][row] = .record
                }
                
                // 前进5分钟
                currentTime = calendar.date(byAdding: .minute, value: 5, to: currentTime) ?? endTime
            }
        }
        
        // 更新heatmapData，同时保持当前时间点的状态
        for hour in 0..<24 {
            for row in 0..<12 {
                if heatmapData[hour][row] == .now && newHeatmapData[hour][row] == .record {
                    // 如果当前是now且新数据是record，则设为nowWithRecord
                    newHeatmapData[hour][row] = .nowWithRecord
                } else if heatmapData[hour][row] == .now {
                    // 保持now状态
                    newHeatmapData[hour][row] = .now
                }
            }
        }
        
        heatmapData = newHeatmapData
    }
    
    private func updateCurrentTimeDot() {
        // Reset all dots with .now status
        for column in 0..<heatmapData.count {
            for row in 0..<heatmapData[column].count {
                if heatmapData[column][row] == .now {
                    heatmapData[column][row] = .blank
                } else if heatmapData[column][row] == .nowWithRecord {
                    heatmapData[column][row] = .record
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
        
        // Update current time dot status to .now or .nowWithRecord
        if hour < heatmapData.count && row < heatmapData[0].count {
            if heatmapData[hour][row] == .record {
                heatmapData[hour][row] = .nowWithRecord
            } else {
                heatmapData[hour][row] = .now
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, Icon.self, TimeLog.self, configurations: config)
    
    // 创建样本标签
    let sampleLabel = Label(name: "测试", icon: .dog)
    container.mainContext.insert(sampleLabel)
    
    // 创建当天的样本时间日志
    let calendar = Calendar.current
    let now = Date()
    
    // 创建当天不同时间段的记录
    let morningStart = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
    let morningEnd = calendar.date(bySettingHour: 10, minute: 30, second: 0, of: now)!
    container.mainContext.insert(TimeLog(startTime: morningStart, endTime: morningEnd, label: sampleLabel))
    
    let noonStart = calendar.date(bySettingHour: 12, minute: 15, second: 0, of: now)!
    let noonEnd = calendar.date(bySettingHour: 13, minute: 45, second: 0, of: now)!
    container.mainContext.insert(TimeLog(startTime: noonStart, endTime: noonEnd, label: sampleLabel))
    
    let afternoonStart = calendar.date(bySettingHour: 15, minute: 30, second: 0, of: now)!
    let afternoonEnd = calendar.date(bySettingHour: 16, minute: 45, second: 0, of: now)!
    container.mainContext.insert(TimeLog(startTime: afternoonStart, endTime: afternoonEnd, label: sampleLabel))
    
    return Heatmap()
        .modelContainer(container)
}
