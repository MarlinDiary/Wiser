//
//  LogItem.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct LogItem: View {
    @Binding var timeLog: TimeLog
    
    private func formattedTimeRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let startTimeString = formatter.string(from: timeLog.startTime)
        
        if let endTime = timeLog.endTime {
            let endTimeString = formatter.string(from: endTime)
            return "\(startTimeString) - \(endTimeString)"
        } else {
            return "\(startTimeString) - Unfinished"
        }
    }
    
    private func calculateDurationInHours() -> String {
        let endTime = timeLog.endTime ?? Date()
        let duration = endTime.timeIntervalSince(timeLog.startTime)
        let hours = duration / 3600.0
        return String(format: "%.1f H", hours)
    }
    
    var body: some View {
        HStack {
            LabelAvatar(label: timeLog.label!)
                .padding(.trailing)
            VStack(alignment: .leading, spacing: 6) {
                Text(timeLog.label!.name)
                    .fontWeight(.medium)
                Text(formattedTimeRange())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(calculateDurationInHours())
                .font(.title2)
                .fontWeight(.medium)
        }
        //.padding()
    }
}

#Preview {
    LogItem(timeLog: .constant(TimeLog.exampleTimeLogs[1]))
}
