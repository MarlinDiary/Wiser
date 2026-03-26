//
//  ContentView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                Spacer()
                RockStackView(state: .idle)
                    .scaleEffect(0.5)
                    .frame(height: 364 * 0.5)
                    .padding(.bottom, 16)
                Text(formattedDuration(totalMinutes: 0))
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                Spacer()
                Button(action: {
                    // TODO
                }) {
                    Label("Start Focus", systemImage: "play.fill")
                        .font(.headline)
                        .padding(8)
                }
                .buttonStyle(.glass)
            }
        }
    }
}

#Preview {
    ContentView()
}
