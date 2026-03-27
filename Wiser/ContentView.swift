//
//  ContentView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var locationManager = LocationManager()
    @State private var greetingProvider = GreetingProvider()
    @State private var isFocusing = false
    @State private var isPaused = false
    @State private var isMusicOn = false
    @State private var isBrightScreen = false
    @State private var focusMinutes = 0
    @State private var timer: Timer?

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
                        if isFocusing {
                            isBrightScreen.toggle()
                        }
                    }) {
                        Image(systemName: isFocusing ? (isBrightScreen ? "sun.max.fill" : "sun.min") : "gear")
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
                        if isFocusing {
                            isMusicOn.toggle()
                        }
                    }) {
                        Image(systemName: isFocusing ? (isMusicOn ? "music.note" : "music.note.slash") : "plus")
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
                Label("Today 0 min", systemImage: greetingProvider.displaySymbol)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 16)
                    .opacity(isFocusing ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: isFocusing)
                RockStackView(state: isFocusing ? (isPaused ? .paused : .checked) : .idle)
                    .scaleEffect(0.66)
                    .frame(height: 364 * 0.66)
                    .padding(.bottom, 16)
                Text(formattedDuration(totalMinutes: focusMinutes))
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                Spacer()
                ZStack {
                    Button(action: {
                        if isFocusing {
                            isFocusing = false
                            isPaused = false
                            isMusicOn = false
                            isBrightScreen = false
                            timer?.invalidate()
                            timer = nil
                        } else {
                            isFocusing = true
                            focusMinutes = 0
                            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                                focusMinutes += 1
                            }
                        }
                    }) {
                        Label(isFocusing ? "Stop" : "Start Focus",
                              systemImage: isFocusing ? "stop.fill" : "play.fill")

                            .font(.headline)
                            .padding(8)
                    }
                    .buttonStyle(.glass)

                    HStack {
                        Button(action: {
                            // TODO
                        }) {
                            Image(systemName: isFocusing ? "backward.end.fill" : "chart.bar.fill")
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
                            if isFocusing {
                                if isPaused {
                                    isPaused = false
                                    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                                        focusMinutes += 1
                                    }
                                } else {
                                    isPaused = true
                                    timer?.invalidate()
                                    timer = nil
                                }
                            }
                        }) {
                            Image(systemName: isFocusing ? (isPaused ? "play.fill" : "pause.fill") : "sparkles")
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
}
