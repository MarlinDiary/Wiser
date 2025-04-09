//
//  DialContent.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData
import Combine

struct Dial: View {
    @Binding var currentLabel: Label
    @Binding var status: HomeStatus
    var labels: [Label]
    var tempRecords: [TempTimeRecord]
    
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerConnector: Cancellable?
    @State private var currentTime = Date()
    
    private var formattedTimeForCurrentLabel: (hours: String, minutes: String, useHoursFormat: Bool) {
        // 计算当前标签的总时长
        let totalSeconds = tempRecords.reduce(0.0) { result, record in
            // 只计算当前标签的记录
            guard record.label.id == currentLabel.id else { return result }
            
            // 如果没有结束时间，则使用当前时间
            let endTime = record.endTime ?? currentTime
            let duration = endTime.timeIntervalSince(record.startTime)
            return result + duration
        }
        
        // 确定显示格式
        let useHoursFormat = totalSeconds >= 3600
        
        if useHoursFormat {
            // 时分格式
            let hours = Int(totalSeconds) / 3600
            let minutes = (Int(totalSeconds) % 3600) / 60
            return (String(format: "%02d", hours), String(format: "%02d", minutes), true)
        } else {
            // 分秒格式
            let minutes = Int(totalSeconds) / 60
            let seconds = Int(totalSeconds) % 60
            return (String(format: "%02d", minutes), String(format: "%02d", seconds), false)
        }
    }
    
    var body: some View {
        TabView(selection: Binding(
            get: { currentLabel.id },
            set: { newValue in
                if let index = labels.firstIndex(where: { $0.id == newValue }) {
                    currentLabel = labels[index]
                }
            }
        )) {
            ForEach(labels, id: \.id) { label in
                VStack {
                    if status != .home {
                        HStack(alignment: .center, spacing: 2) {
                            Text(label.id == currentLabel.id ? formattedTimeForCurrentLabel.hours : "00")
                                .font(.system(size: 36))
                                .fontWeight(.heavy)
                                .frame(width: 60, alignment: .trailing)
                            Text(":")
                                .font(.system(size: 36))
                                .fontWeight(.heavy)
                                .baselineOffset(0)
                            Text(label.id == currentLabel.id ? formattedTimeForCurrentLabel.minutes : "00")
                                .font(.system(size: 36))
                                .fontWeight(.heavy)
                                .frame(width: 60, alignment: .leading)
                        }
                        .offset(x: 0, y: 46)
                    }
                    
                    Image(label.icon.image)
                        .resizable()
                        .saturation(status == .home ? 0.25 : 1)
                        .frame(width: status == .home ? 228 : 170, height: status == .home ? 228 : 170)
                        .offset(x: 0, y: 25)
                }
                .tag(label.id)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: 221, height: 221)
        .clipShape(Circle())
        .overlay {
            DialScale()
        }
        .background {
            DialBackground()
        }
        .onAppear {
            // 启动计时器进行实时更新
            self.timerConnector = self.timer.connect()
        }
        .onReceive(timer) { _ in
            self.currentTime = Date()
        }
        .onDisappear {
            self.timerConnector?.cancel()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]),
                status: .constant(.home),
                labels: sampleLabels,
                tempRecords: [])
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]),
                status: .constant(.log),
                labels: sampleLabels,
                tempRecords: [])
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]),
                status: .constant(.count),
                labels: sampleLabels,
                tempRecords: [])
        .modelContainer(container)
}
