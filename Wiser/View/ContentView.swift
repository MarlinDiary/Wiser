//
//  ContentView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var status: HomeStatus = .home
    @State var currentLabel: Label?
    @State var checkInTime: Date?
    
    @Query private var labels: [Label]
    @Query private var allTimeLogs: [TimeLog]
    
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
        guard let checkInTime = checkInTime else {
            return ("0", "HOUR")
        }
        
        let durationInSeconds = Date().timeIntervalSince(checkInTime)
        let minutes = Int(durationInSeconds / 60)
        
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
                    LabelIndicator(status: $status, currentLabel: currentLabel)
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
                    set: { self.currentLabel = $0 }
                ), status: $status, labels: labels)
            }
            
            Spacer()
            Spacer()
            
            if status != .count {
                HeroTitle(hour: totalTimeToday.hour, minute: totalTimeToday.minute)
                
                Spacer()
                
                Heatmap()
            } else {
                CountInfo(logo:"clock", name:"Start time", number: formattedCheckInTime.number, unit: formattedCheckInTime.unit)
                    .padding(.bottom, 42)
                
                CountInfo(logo:"ruler", name:"Total duration", number: formattedDuration.number, unit: formattedDuration.unit)
                
                 Spacer()
                
                Tip(title: "Focus Tip", content: "If you study until 12:30, you will exceed the duration of your study from yesterday morning.")
            }
            
            Spacer()
            
            HomeButton(status: $status, currentLabel: $currentLabel, checkInTime: $checkInTime)
        }
        .onAppear {
            if labels.count > 0 && currentLabel == nil {
                currentLabel = labels.first
            }
        }
        .onChange(of: labels) { oldValue, newValue in
            if newValue.count > 0 && currentLabel == nil {
                currentLabel = newValue.first
            }
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
