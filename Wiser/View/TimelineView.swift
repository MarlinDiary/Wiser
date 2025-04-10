//
//  TimelineView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI
import SwiftData

struct TimelineView: View {
    @Query(sort: \TimeLog.startTime, order: .reverse) private var timeLogs: [TimeLog]
    @State private var selectedLog: TimeLog?
    
    // 按日期分组的时间日志
    private var groupedLogs: [Date: [TimeLog]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: timeLogs) { log in
            // 移除时间部分，只保留日期部分
            return calendar.startOfDay(for: log.startTime)
        }
        return grouped
    }
    
    // 获取分组的日期键，按降序排列
    private var sortedDays: [Date] {
        return groupedLogs.keys.sorted(by: >)
    }
    
    // 格式化日期为易读的字符串
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today"
        } else if calendar.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if timeLogs.isEmpty {
                    Section {
                        Text("Empty Log")
                    }
                } else {
                    ForEach(sortedDays, id: \.self) { day in
                        Section(header: 
                            VStack(alignment: .leading, spacing: 8) {
                                Text(formatDate(day))
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                            }
                        ) {
                            ForEach(groupedLogs[day] ?? [], id: \.id) { log in
                                LogItem(timeLog: .constant(log))
                                    .contentShape(Rectangle())
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listSectionSeparator(.hidden)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .navigationTitle("Timeline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, Icon.self, TimeLog.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    // 创建10个示例日志
    let calendar = Calendar.current
    let now = Date()
    
    // 今天的日志
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(byAdding: .hour, value: -1, to: now)!,
        endTime: now,
        label: sampleLabels[0]
    ))
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(byAdding: .hour, value: -3, to: now)!,
        endTime: calendar.date(byAdding: .hour, value: -2, to: now)!,
        label: sampleLabels[1]
    ))
    
    // 昨天的日志
    let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: yesterday)!,
        endTime: calendar.date(bySettingHour: 11, minute: 30, second: 0, of: yesterday)!,
        label: sampleLabels[2]
    ))
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: yesterday)!,
        endTime: calendar.date(bySettingHour: 15, minute: 45, second: 0, of: yesterday)!,
        label: sampleLabels[0]
    ))
    
    // 前天的日志
    let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now)!
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 9, minute: 15, second: 0, of: twoDaysAgo)!,
        endTime: calendar.date(bySettingHour: 10, minute: 45, second: 0, of: twoDaysAgo)!,
        label: sampleLabels[1]
    ))
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: twoDaysAgo)!,
        endTime: calendar.date(bySettingHour: 13, minute: 50, second: 0, of: twoDaysAgo)!,
        label: sampleLabels[2]
    ))
    
    // 三天前的日志
    let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now)!
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: threeDaysAgo)!,
        endTime: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: threeDaysAgo)!,
        label: sampleLabels[0]
    ))
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 15, minute: 30, second: 0, of: threeDaysAgo)!,
        endTime: calendar.date(bySettingHour: 16, minute: 45, second: 0, of: threeDaysAgo)!,
        label: sampleLabels[1]
    ))
    
    // 四天前的日志
    let fourDaysAgo = calendar.date(byAdding: .day, value: -4, to: now)!
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: fourDaysAgo)!,
        endTime: calendar.date(bySettingHour: 11, minute: 45, second: 0, of: fourDaysAgo)!,
        label: sampleLabels[2]
    ))
    
    container.mainContext.insert(TimeLog(
        startTime: calendar.date(bySettingHour: 14, minute: 30, second: 0, of: fourDaysAgo)!,
        endTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: fourDaysAgo)!,
        label: sampleLabels[0]
    ))
    
    return TimelineView()
        .modelContainer(container)
}
