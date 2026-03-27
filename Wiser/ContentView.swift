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
                        // TODO
                    }) {
                        Image(systemName: "gear")
                            .font(.headline)
                            .padding(8)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .padding(.leading, 16)
                    Spacer()
                    Button(action: {
                        // TODO
                    }) {
                        Image(systemName: "plus")
                            .font(.headline)
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
                RockStackView(state: .idle)
                    .scaleEffect(0.5)
                    .frame(height: 364 * 0.5)
                    .padding(.bottom, 16)
                Text(formattedDuration(totalMinutes: 0))
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                Spacer()
                ZStack {
                    Button(action: {
                        // TODO
                    }) {
                        Label("Start Focus", systemImage: "play.fill")
                            .font(.headline)
                            .padding(8)
                    }
                    .buttonStyle(.glass)

                    HStack {
                        Button(action: {
                            // TODO
                        }) {
                            Image(systemName: "chart.bar.fill")
                                .font(.headline)
                                .padding(8)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .padding(.leading, 16)
                        Spacer()
                        Button(action: {
                            // TODO
                        }) {
                            Image(systemName: "sparkles")
                                .font(.headline)
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
