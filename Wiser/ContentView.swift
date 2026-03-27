//
//  ContentView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query private var allSessions: [FocusSession]
    @State private var locationManager = LocationManager()
    @State private var greetingProvider = GreetingProvider()
    @State private var focusTimer = FocusTimer()
    @State private var isMusicOn = false
    @State private var isBrightScreen = false

    private var todayMinutes: Int {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return allSessions
            .filter { $0.startDate >= startOfDay }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    var backgroundColor: Color {
        Color(.secondarySystemBackground)
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
                        }
                    }) {
                        Image(systemName: focusTimer.isRunning ? (isMusicOn ? "music.note" : "music.note.slash") : "plus")
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
                Label("Today \(formattedDuration(totalMinutes: todayMinutes))", systemImage: greetingProvider.displaySymbol)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 16)
                    .opacity(focusTimer.isRunning ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: focusTimer.isRunning)
                RockStackView(state: focusTimer.isRunning ? (focusTimer.isPaused ? .paused : .checked) : .idle)
                    .scaleEffect(0.66)
                    .frame(height: 364 * 0.66)
                    .padding(.bottom, 16)
                Text(formattedDuration(totalMinutes: focusTimer.totalMinutes))
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                Spacer()
                ZStack {
                    Button(action: {
                        if focusTimer.isRunning {
                            if let result = focusTimer.stop() {
                                let session = FocusSession(startDate: result.startDate, durationSeconds: result.duration)
                                modelContext.insert(session)
                            }
                            isMusicOn = false
                            isBrightScreen = false
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
                            // TODO
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
        .task(id: locationManager.location?.coordinate.latitude) {
            if let location = locationManager.location {
                await greetingProvider.fetchWeather(for: location)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FocusSession.self, inMemory: true)
}
