//
//  HistoryView.swift
//  Wiser
//
//  Created by Marlin on 29/03/2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FocusSession.startDate, order: .reverse) private var sessions: [FocusSession]

    private var groupedSessions: [(date: String, sessions: [FocusSession])] {
        let grouped = Dictionary(grouping: sessions) { session in
            Calendar.current.startOfDay(for: session.startDate)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (date: formatSectionDate($0.key), sessions: $0.value) }
    }

    private func formatSectionDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedSessions, id: \.date) { group in
                    Section(group.date) {
                        ForEach(group.sessions) { session in
                            HStack {
                                Text(session.startDate, style: .time)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(formattedDuration(seconds: session.durationSeconds))
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.medium)
                            }
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                modelContext.delete(group.sessions[index])
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollIndicators(.hidden)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.fraction(0.95)])
        .presentationDragIndicator(.visible)
    }

    private func formattedDuration(seconds: TimeInterval) -> String {
        let totalMinutes = Int(seconds) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours == 0 {
            return "\(minutes) min"
        } else if minutes == 0 {
            return "\(hours) hr"
        } else {
            return "\(hours)hr \(minutes)min"
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: FocusSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    SampleData.insert(into: container.mainContext)
    return HistoryView()
        .modelContainer(container)
}
