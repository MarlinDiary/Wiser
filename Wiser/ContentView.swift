//
//  ContentView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI
import SwiftData
import CoreLocation
import Combine

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Query private var allSessions: [FocusSession]
    @State private var locationManager = LocationManager()
    @State var greetingProvider = GreetingProvider()
    @State private var focusTimer = FocusTimer()
    @State private var isMusicOn = false
    @State private var isBrightScreen = false
    @State private var showStats = false
    @State private var showHistory = false

    private var todayMinutes: Int {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return allSessions
            .filter { $0.startDate >= startOfDay }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    var backgroundColor: Color {
        Color(.secondarySystemBackground)
    }

    private var focusDisplay: String {
        let totalSeconds = Int(focusTimer.elapsedSeconds)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    private func formattedDuration(totalMinutes: Int) -> String {
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

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            Image("NoiseTexture")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
                .opacity(colorScheme == .dark ? 0.05 : 1)
            VStack {
                HStack {
                    Button(action: {
                        if focusTimer.isRunning {
                            isBrightScreen.toggle()
                        }
                    }) {
                        Image(systemName: focusTimer.isRunning ? (isBrightScreen ? "sun.max.fill" : "sun.min") : "gear")
                            .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
                            .font(.headline)
                            .frame(width: 20, height: 20)
                            .padding(8)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .padding(.leading, 16)
                    Spacer()
                    Button(action: {
                        if focusTimer.isRunning {
                            isMusicOn.toggle()
                        } else {
                            showHistory = true
                        }
                    }) {
                        Image(systemName: focusTimer.isRunning ? (isMusicOn ? "music.note" : "music.note.slash") : "text.page")
                            .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
                            .font(.headline)
                            .frame(width: 20, height: 20)
                            .padding(8)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .padding(.trailing, 16)
                }
                Spacer()
                Label(greetingProvider.greeting, systemImage: greetingProvider.displaySymbol)
                    .contentTransition(.symbolEffect(.replace))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(greetingProvider.greetingColor)
                    .padding(.bottom, 16)
                    .opacity(focusTimer.isRunning ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: focusTimer.isRunning)
                RockStackView(state: focusTimer.isRunning ? (focusTimer.isPaused ? .paused : .checked) : .idle)
                    .scaleEffect(0.66)
                    .frame(height: 364 * 0.66)
                    .padding(.bottom, 16)
                Text(focusDisplay)
                    .font(.system(size: 48, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .animation(.linear(duration: 0.3), value: focusDisplay)
                Spacer()
                ZStack {
                    Button(action: {
                        if focusTimer.isRunning {
                            if let result = focusTimer.stop(), result.duration >= 300 {
                                for session in FocusSession.splitByDay(startDate: result.startDate, durationSeconds: result.duration) {
                                    modelContext.insert(session)
                                }
                            }
                            isMusicOn = false
                            isBrightScreen = false
                            if let location = locationManager.location {
                                Task { await greetingProvider.fetchWeather(for: location) }
                            }
                        } else {
                            focusTimer.start()
                        }
                    }) {
                        Label(focusTimer.isRunning ? "Stop" : "Start Focus",
                              systemImage: focusTimer.isRunning ? "stop.fill" : "play.fill")

                            .font(.headline)
                            .padding(8)
                    }
                    .buttonStyle(.glass)

                    HStack {
                        Button(action: {
                            if !focusTimer.isRunning {
                                showStats = true
                            }
                        }) {
                            Image(systemName: focusTimer.isRunning ? "backward.end.fill" : "chart.bar.fill")
                                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
                                .font(.headline)
                                .frame(width: 20, height: 20)
                                .padding(8)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .padding(.leading, 16)
                        Spacer()
                        Button(action: {
                            if focusTimer.isRunning {
                                if focusTimer.isPaused {
                                    focusTimer.resume()
                                } else {
                                    focusTimer.pause()
                                }
                            }
                        }) {
                            Image(systemName: focusTimer.isRunning ? (focusTimer.isPaused ? "play.fill" : "pause.fill") : "sparkles")
                                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
                                .font(.headline)
                                .frame(width: 20, height: 20)
                                .padding(8)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .padding(.trailing, 16)
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                focusTimer.refreshOnForeground()
            }
        }
        .task(id: locationManager.location?.coordinate.latitude) {
            guard let location = locationManager.location else { return }
            await greetingProvider.fetchWeather(for: location)
        }
        .onReceive(Timer.publish(every: 30 * 60, on: .main, in: .common).autoconnect()) { _ in
            if let location = locationManager.location {
                Task { await greetingProvider.fetchWeather(for: location) }
            }
        }
        .sheet(isPresented: $showStats) {
            StatsView()
        }
        .sheet(isPresented: $showHistory) {
            HistoryView()
        }
    }
}

#Preview("Morning") {
    let container = try! ModelContainer(for: FocusSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    SampleData.insert(into: container.mainContext)
    return ContentView(greetingProvider: GreetingProvider(preview: "Good morning", symbol: "sun.max"))
        .modelContainer(container)
}

#Preview("Afternoon") {
    let container = try! ModelContainer(for: FocusSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return ContentView(greetingProvider: GreetingProvider(preview: "Good afternoon", symbol: "cloud.sun.fill"))
        .modelContainer(container)
}

#Preview("Evening") {
    let container = try! ModelContainer(for: FocusSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return ContentView(greetingProvider: GreetingProvider(preview: "Good evening", symbol: "sun.horizon.fill"))
        .modelContainer(container)
}

#Preview("Night") {
    let container = try! ModelContainer(for: FocusSession.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return ContentView(greetingProvider: GreetingProvider(preview: "Good night", symbol: "moon.stars"))
        .modelContainer(container)
}
