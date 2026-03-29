//
//  StatsView.swift
//  Wiser
//
//  Created by Marlin on 28/03/2026.
//

import SwiftUI
import SwiftData

enum StatsPeriod: String, CaseIterable {
    case day = "D"
    case week = "W"
    case month = "M"
    case year = "Y"
}

struct ChartEntry: Identifiable {
    let id = UUID()
    let label: String
    let minutes: Int
    let isCurrent: Bool
}

struct FocusChartView: View {
    let data: [ChartEntry]
    let gridLines: [(value: Int, label: String)]
    let maxValue: Int
    let barWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            let chartHeight = geo.size.height - 20
            let spacing = geo.size.width / CGFloat(data.count)

            ZStack(alignment: .topLeading) {
                ForEach(gridLines, id: \.value) { line in
                    let y = chartHeight - (CGFloat(line.value) / CGFloat(maxValue)) * chartHeight
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
                    .foregroundStyle(.quaternary)

                    Text(line.label)
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                        .position(x: geo.size.width - 14, y: y + 10)
                }

                ForEach(Array(data.enumerated()), id: \.element.id) { index, entry in
                    let x = spacing * CGFloat(index) + spacing / 2
                    let barHeight = entry.minutes > 0
                        ? max(CGFloat(entry.minutes) / CGFloat(maxValue) * chartHeight, barWidth)
                        : barWidth
                    let y = chartHeight - barHeight

                    Capsule()
                        .fill(Color.accentColor.opacity(entry.isCurrent ? 0.8 : 0.3))
                        .frame(width: barWidth, height: barHeight)
                        .position(x: x, y: y + barHeight / 2)
                }

                ForEach(Array(data.enumerated()), id: \.element.id) { index, entry in
                    let x = spacing * CGFloat(index) + spacing / 2
                    if shouldShowLabel(index: index, label: entry.label) {
                        Text(entry.label.trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .position(x: x, y: chartHeight + 12)
                    }
                }
            }
        }
    }

    private func shouldShowLabel(index: Int, label: String) -> Bool {
        if data.count <= 12 { return true }
        if data.count == 24 { return index % 6 == 0 }
        let day = index + 1
        return [1, 7, 14, 21, 28].contains(day)
    }
}

struct StatsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Query private var allSessions: [FocusSession]
    @State private var selectedPeriod: StatsPeriod = .day
    @State private var offset: Int = 0

    private var referenceDate: Date {
        let calendar = Calendar.current
        let now = Date()
        switch selectedPeriod {
        case .day: return calendar.date(byAdding: .day, value: offset, to: now)!
        case .week: return calendar.date(byAdding: .weekOfYear, value: offset, to: now)!
        case .month: return calendar.date(byAdding: .month, value: offset, to: now)!
        case .year: return calendar.date(byAdding: .year, value: offset, to: now)!
        }
    }

    private var periodTitle: String {
        let calendar = Calendar.current
        let ref = referenceDate
        let formatter = DateFormatter()

        switch selectedPeriod {
        case .day:
            if calendar.isDateInToday(ref) { return "Today" }
            if calendar.isDateInYesterday(ref) { return "Yesterday" }
            formatter.dateFormat = "MMM d"
            return formatter.string(from: ref)
        case .week:
            if offset == 0 { return "This Week" }
            if offset == -1 { return "Last Week" }
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: ref))!
            let end = calendar.date(byAdding: .day, value: 6, to: start)!
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        case .month:
            if offset == 0 { return "This Month" }
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: ref)
        case .year:
            if offset == 0 { return "This Year" }
            formatter.dateFormat = "yyyy"
            return formatter.string(from: ref)
        }
    }

    private var chartData: [ChartEntry] {
        let calendar = Calendar.current
        let ref = referenceDate
        let isCurrentPeriod = offset == 0
        let currentHour = calendar.component(.hour, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        let currentWeekday = calendar.component(.weekday, from: Date())
        let currentMonth = calendar.component(.month, from: Date())

        switch selectedPeriod {
        case .day:
            let startOfDay = calendar.startOfDay(for: ref)
            return (0..<24).map { hour in
                let hourStart = calendar.date(byAdding: .hour, value: hour, to: startOfDay)!
                let hourEnd = calendar.date(byAdding: .hour, value: hour + 1, to: startOfDay)!
                let mins = sessionsMinutes(from: hourStart, to: hourEnd)
                return ChartEntry(label: "\(hour)", minutes: mins, isCurrent: isCurrentPeriod && hour == currentHour)
            }

        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: ref))!
            let weekLabels = ["M", "T", "W", "T ", "F", "S", "S "]
            let weekdayIndex = (currentWeekday - calendar.firstWeekday + 7) % 7
            return (0..<7).map { day in
                let dayStart = calendar.date(byAdding: .day, value: day, to: startOfWeek)!
                let dayEnd = calendar.date(byAdding: .day, value: day + 1, to: startOfWeek)!
                let mins = sessionsMinutes(from: dayStart, to: dayEnd)
                return ChartEntry(label: weekLabels[day], minutes: mins, isCurrent: isCurrentPeriod && day == weekdayIndex)
            }

        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: ref))!
            let range = calendar.range(of: .day, in: .month, for: ref)!
            return range.map { day in
                let dayStart = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
                let dayEnd = calendar.date(byAdding: .day, value: day, to: startOfMonth)!
                let mins = sessionsMinutes(from: dayStart, to: dayEnd)
                return ChartEntry(label: "\(day)", minutes: mins, isCurrent: isCurrentPeriod && day == currentDay)
            }

        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: ref))!
            return (0..<12).map { month in
                let monthStart = calendar.date(byAdding: .month, value: month, to: startOfYear)!
                let monthEnd = calendar.date(byAdding: .month, value: month + 1, to: startOfYear)!
                let mins = sessionsMinutes(from: monthStart, to: monthEnd)
                return ChartEntry(label: "\(month + 1)", minutes: mins, isCurrent: isCurrentPeriod && (month + 1) == currentMonth)
            }
        }
    }

    private var totalMinutes: Int {
        chartData.reduce(0) { $0 + $1.minutes }
    }

    private func sessionsMinutes(from start: Date, to end: Date) -> Int {
        allSessions
            .filter { $0.startDate >= start && $0.startDate < end }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    private var barWidth: CGFloat {
        switch selectedPeriod {
        case .day: 8
        case .week: 20
        case .month: 6
        case .year: 14
        }
    }

    private var chartMaxValue: Int {
        let dataMax = chartData.map(\.minutes).max() ?? 0
        let rawMax = max(dataMax, 60)
        let step = max(1, Int(ceil(Double(rawMax) / 4.0)))
        let niceStep: Int
        if step <= 15 { niceStep = 15 }
        else if step <= 30 { niceStep = 30 }
        else if step <= 60 { niceStep = 60 }
        else { niceStep = ((step + 29) / 30) * 30 }
        return niceStep * 4
    }

    private var gridLines: [(value: Int, label: String)] {
        let maxVal = chartMaxValue
        return (1...4).map { i in
            let value = maxVal * i / 4
            let label: String
            if value >= 60 && value % 60 == 0 {
                label = "\(value / 60)h"
            } else if value >= 60 {
                label = "\(value / 60)h\(value % 60)m"
            } else {
                label = "\(value)m"
            }
            return (value, label)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(formattedTotal)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)

                FocusChartView(
                    data: chartData,
                    gridLines: gridLines,
                    maxValue: chartMaxValue,
                    barWidth: barWidth
                )
                .frame(height: 240)
                .padding(.horizontal)
            }
            .padding(.top, 0)
            .padding(.bottom, 16)
            .navigationBarTitleDisplayMode(.inline)
            .containerBackground(.clear, for: .navigation)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(StatsPeriod.allCases, id: \.self) { period in
                            Button(action: {
                                selectedPeriod = period
                                offset = 0
                            }) {
                                Label(periodLabel(period), systemImage: selectedPeriod == period ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 16) {
                        Button(action: { offset -= 1 }) {
                            Image(systemName: "chevron.left")
                                .font(.caption)
                        }
                        Text(periodTitle)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                        Button(action: {
                            if offset < 0 { offset += 1 }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .disabled(offset >= 0)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // TODO: share
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                    }
                }
            }
        }
        .presentationDetents([.height(440)])
        .presentationDragIndicator(.visible)
    }

    private func periodLabel(_ period: StatsPeriod) -> String {
        switch period {
        case .day: "Day"
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        }
    }

    private var formattedTotal: String {
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
    StatsView()
        .modelContainer(for: FocusSession.self, inMemory: true)
}
