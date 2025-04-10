//
//  ContentView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData
import Foundation
import Combine

struct ContentView: View {
    
    @State var status: HomeStatus = .home
    @State var currentLabel: Label?
    @AppStorage("selectedLabelID") private var selectedLabelID: String = ""
    @State var checkInTime: Date?
    @State private var tempRecords: [TempTimeRecord] = []
    @State private var currentTime = Date()
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerConnector: Cancellable?
    @State private var showingTimeline = false
    @State private var showingLabelView = false
    
    @Query(sort: \Label.name) private var labels: [Label]
    @Query private var allTimeLogs: [TimeLog]
    @Environment(\.modelContext) private var modelContext
    
    // 添加或更新临时记录的方法
    private func addOrUpdateTempRecord(for label: Label) {
        let now = Date()
        
        // 如果已经有活跃的记录，为其设置结束时间
        if let lastIndex = tempRecords.lastIndex(where: { $0.endTime == nil }) {
            var lastRecord = tempRecords[lastIndex]
            lastRecord.endTime = now
            tempRecords[lastIndex] = lastRecord
            
            // 检查这条记录的持续时间是否小于30秒
            if let endTime = lastRecord.endTime, endTime.timeIntervalSince(lastRecord.startTime) < 30 {
                tempRecords.remove(at: lastIndex)
            }
        }
        
        // 为新的标签创建一条记录
        if status == .count {
            tempRecords.append(TempTimeRecord(startTime: now, label: label))
        }
    }
    
    var todayTimeLogs: [TimeLog] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return allTimeLogs.filter { timeLog in
            timeLog.startTime >= startOfDay && timeLog.startTime < endOfDay
        }.sorted { $0.startTime < $1.startTime }
    }
    
    var totalTimeToday: (hour: String, minute: String) {
        let totalSeconds = todayTimeLogs.reduce(0) { result, timeLog in
            guard let endTime = timeLog.endTime else {
                let duration = Date().timeIntervalSince(timeLog.startTime)
                return result + duration
            }
            let duration = endTime.timeIntervalSince(timeLog.startTime)
            return result + duration
        }
        
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        
        return (String(format: "%02d", hours), String(format: "%02d", minutes))
    }
    
    var formattedDuration: (number: String, unit: String) {
        // 使用tempRecords计算总时长
        let totalSeconds = tempRecords.reduce(0.0) { result, record in
            // 如果没有结束时间，则使用当前时间
            let endTime = record.endTime ?? currentTime
            let duration = endTime.timeIntervalSince(record.startTime)
            return result + duration
        }
        
        let minutes = Int(totalSeconds / 60)
        
        if minutes < 60 {
            return (String(minutes), "MIN")
        } else {
            let hours = Double(minutes) / 60.0
            return (String(format: "%.1f", hours), "HOUR")
        }
    }
    
    var formattedCheckInTime: (number: String, unit: String) {
        guard let checkInTime = checkInTime else {
            return ("--:--", "")
        }
        
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: checkInTime)
        
        if hour < 12 {
            formatter.dateFormat = "hh:mm"
            return (formatter.string(from: checkInTime), "AM")
        } else {
            formatter.dateFormat = "hh:mm"
            return (formatter.string(from: checkInTime), "PM")
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if let currentLabel = currentLabel {
                    Button {
                        showingLabelView = true
                    } label: {
                        LabelIndicator(status: $status, currentLabel: currentLabel)
                            .foregroundStyle(.black)
                    }
                    .disabled(status == .count || status == .log)
                }
                Spacer()
                HomeStatusControl(status: $status)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
            
            if let currentLabel = currentLabel {
                Dial(currentLabel: Binding(
                    get: { currentLabel },
                    set: { 
                        // 当标签变化时，更新记录
                        if self.currentLabel != $0 {
                            if let oldLabel = self.currentLabel {
                                addOrUpdateTempRecord(for: oldLabel)
                            }
                            self.currentLabel = $0
                            // 如果在计时状态下，为新标签创建记录
                            if status == .count {
                                addOrUpdateTempRecord(for: $0)
                            }
                        }
                    }
                ), status: $status, labels: labels, tempRecords: tempRecords)
            }
            
            Spacer()
            Spacer()
            
            if status != .count {
                HeroTitle(hour: totalTimeToday.hour, minute: totalTimeToday.minute)
                
                Spacer()
                
                Button {
                    showingTimeline = true
                } label: {
                    Heatmap()
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                CountInfo(logo:"clock", name:"Start time", number: formattedCheckInTime.number, unit: formattedCheckInTime.unit)
                    .padding(.bottom, 33)
                
                CountInfo(logo:"ruler", name:"Total duration", number: formattedDuration.number, unit: formattedDuration.unit)
                
                 Spacer()
                
                Tip(title: "Focus Tip", content: "If you study until 12:30, you will exceed the duration of your study from yesterday morning.")
            }
            
            Spacer()
            
            HomeButton(status: $status, currentLabel: $currentLabel, checkInTime: $checkInTime, tempRecords: $tempRecords)
        }
        .popover(isPresented: $showingTimeline) {
            TimelineView()
        }
        .popover(isPresented: $showingLabelView) {
            LabelView()
        }
        .onAppear {
            if let savedID = UUID(uuidString: selectedLabelID),
               let savedLabel = labels.first(where: { $0.id == savedID }) {
                currentLabel = savedLabel
            } else if labels.count > 0 && currentLabel == nil {
                currentLabel = labels.first
            }
            // 启动计时器
            self.timerConnector = self.timer.connect()
        }
        .onDisappear {
            // 停止计时器
            self.timerConnector?.cancel()
        }
        .onChange(of: labels) { oldValue, newValue in
            if newValue.count > 0 && currentLabel == nil {
                currentLabel = newValue.first
            }
        }
        .onChange(of: currentLabel) { oldValue, newValue in
            if let label = newValue {
                selectedLabelID = label.id.uuidString
            }
        }
        .onReceive(timer) { _ in
            // 更新当前时间
            self.currentTime = Date()
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
    
    let todayLog = TimeLog(
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        label: sampleLabels[0]
    )
    
    container.mainContext.insert(todayLog)
    
    return ContentView()
        .modelContainer(container)
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
    
    let todayLog = TimeLog(
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        label: sampleLabels[0]
    )
    
    container.mainContext.insert(todayLog)
    
    let view = ContentView(status: .count)
    view.checkInTime = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())
    return view
        .modelContainer(container)
}
