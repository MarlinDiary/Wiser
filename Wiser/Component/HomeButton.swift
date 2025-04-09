//
//  HomeButton.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI
import SwiftData
import Foundation

struct HomeButton: View {
    @Binding var status: HomeStatus
    @Environment(\.modelContext) private var modelContext
    @Binding var currentLabel: Label?
    @Binding var checkInTime: Date?
    @Binding var tempRecords: [TempTimeRecord]
    
    var body: some View {
        Button {
            switch status {
            case .home:
                // Check in: 创建初始临时记录并更改状态为count
                if let label = currentLabel {
                    let now = Date()
                    tempRecords.append(TempTimeRecord(startTime: now, label: label))
                    checkInTime = now
                    status = .count
                }
            case .count:
                // Check out: 保存所有临时记录并转换回home状态
                if let lastIndex = tempRecords.lastIndex(where: { $0.endTime == nil }) {
                    var lastRecord = tempRecords[lastIndex]
                    lastRecord.endTime = Date()
                    tempRecords[lastIndex] = lastRecord
                }
                
                // 将所有有效的临时记录保存为TimeLog
                for record in tempRecords {
                    if let endTime = record.endTime {
                        let timeLog = TimeLog(startTime: record.startTime, endTime: endTime, label: record.label)
                        modelContext.insert(timeLog)
                    }
                }
                
                // 清空临时记录
                tempRecords.removeAll()
                checkInTime = nil
                status = .home
            case .log:
                // 处理添加日志（暂未实现）
                status = .home
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 33)
                    .padding(.horizontal)
                    .frame(height: 67)
                    .foregroundStyle(status == .log ? .orange1 : .black)
                Text(status == .home ? "CHECK IN" : status == .count ? "CHECK OUT" : "ADD LOG")
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
            }
        }
    }
}

#Preview {
    HomeButton(status: .constant(.home), currentLabel: .constant(nil), checkInTime: .constant(nil), tempRecords: .constant([]))
}

#Preview {
    HomeButton(status: .constant(.count), currentLabel: .constant(nil), checkInTime: .constant(Date()), tempRecords: .constant([]))
}

#Preview {
    HomeButton(status: .constant(.log), currentLabel: .constant(nil), checkInTime: .constant(nil), tempRecords: .constant([]))
}
