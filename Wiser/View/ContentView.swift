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
    
    var body: some View {
        VStack {
            HStack {
                if let currentLabel = currentLabel {
                    LabelIndicator(status: $status, currentLabel: .constant(currentLabel))
                }
                Spacer()
                HomeStatusControl(status: $status)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
            
            if let currentLabel = currentLabel {
                Dial(currentLabel: .constant(currentLabel), Labels: .constant(labels), status: $status)
            }
            
            Spacer()
            Spacer()
            
            HeroTitle(hour: totalTimeToday.hour, minute: totalTimeToday.minute)
            
            Spacer()
            
            Heatmap()
            
            Spacer()
            
            HomeButton(status: $status)
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
